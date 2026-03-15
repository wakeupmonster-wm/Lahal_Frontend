# API Integration Rules & Guidelines

> **Reference Modules**: `lib/features/auth/` and `lib/features/onboarding/` (Profile Setup)
> **Last Updated**: Feb 14, 2026
> **Status**: Living document — update when new patterns emerge

---

## 1. Purpose

This document is the **single source of truth** for how we integrate APIs in every feature module. It is derived from the **auth** and **onboarding (profile-setup)** modules — the two modules that have been fully refactored and serve as the gold-standard reference.

**Use this document when**:
- Starting a new feature module
- Reviewing a PR that touches API integration
- Debugging an API-related issue

---

## 2. Architecture Overview

```
UI (Screen/Widget)
  │
  ▼
Controller          — orchestrates: validate → prepare → call → handle result
  │
  ▼
Service             — business logic, navigation, data transformation, response parsing
  │
  ▼
API Service         — debouncing, delegates to ApiCallHandler (GetxService)
  │
  ▼
ApiCallHandler      — connectivity check, loading state, try/catch, 401 auto-refresh
  │
  ▼
Repository (Repo)   — raw HTTP calls via NetworkApiServices (plain Dart class)
  │
  ▼
NetworkApiServices  — sends request, parses response into ApiResponse<T>, throws typed AppException
```

**Data flows DOWN. Callbacks flow UP.**

### Key Infrastructure Classes

| Class | Location | Purpose |
|---|---|---|
| `ApiResponse<T>` | `lib/data/models/api_response.dart` | Typed wrapper: `status`, `message`, `data` parsed from `{success, message, data}` |
| `AppException` (sealed) | `lib/data/exceptions/app_exception.dart` | Typed hierarchy: `NetworkException`, `UnauthorizedException`, `BadRequestException`, `ValidationException`, `RateLimitException`, `ServerException`, `ApiStatusFalseException`, `TokenRefreshException`, etc. |
| `ApiCallHandler` | `lib/data/datasources/remote/api_call_handler.dart` | Static `call()` — connectivity check, loading toggle, 401 auto-refresh with retry, typed catch blocks |
| `NetworkApiServices` | `lib/data/datasources/remote/network_api_service.dart` | `sendRequest()` for JSON, `multipartRequest()` for file uploads. All methods return `ApiResponse<T>`. All bodies sent as `jsonEncode`. |
| `AppLogger` | `lib/utils/services/helper/app_logger.dart` | `developer.log` based logger with levels: `d`, `i`, `w`, `e`, `data`, `trace`, `apiRequest`, `apiResponse` |
| `AppDebouncer` | `lib/utils/services/helper/debouncing.dart` | Timer-based debouncer with `run()`, `cancel()`, `isRunning`, `remainingTime` |

---

## 3. Directory Structure (Mandatory)

```
lib/features/[feature_name]/
├── controller/
│   └── [feature]_controller.dart
├── services/
│   ├── [feature]_api_service.dart       # API calls + debouncing (GetxService)
│   ├── [feature]_service.dart           # Business logic + navigation (GetxService)
│   └── [feature]_state_service.dart     # Reactive state (GetxService)
├── utils/
│   ├── [feature]_error_handler.dart     # Centralized error UI (static methods)
│   └── [feature]_validator.dart         # Pure validation functions (static methods)
├── di/
│   └── [feature]_dependencies.dart      # GetX DI setup with init/dispose
├── model/
│   └── [feature]_model.dart             # Data models + fromJson/toJson
├── repo/
│   ├── [feature]_repo.dart              # Abstract interface (or plain class)
│   └── [feature]_repo_impl.dart         # Concrete implementation (plain Dart class)
└── view/
    ├── screens/
    └── widgets/
```

---

## 4. Mistakes Found in Onboarding Module (Learn From These)

### Mistake 1: Debug print statements left in production code

```dart
// BAD - Found in profile_setup_controller.dart, auth_controller.dart
print("submitProfileData --- Called");
print("Token - $token");
print("error: $error");
print("Error $e, Stack Trace $s");
"response ${response.body}".log("reorderPhotosOnServer");
```

**Rule**: Never use `print()` or `.log()` extension. Use `AppLogger` which uses `dart:developer log()` internally — it outputs full data without truncation and is gated behind `kDebugMode`.

```dart
// GOOD - use AppLogger (uses developer.log internally)
AppLogger.d('ProfileSetup', 'submitProfileData called');
AppLogger.e('AuthController', 'Phone registration failed', error);
AppLogger.w('AuthController', 'Logout API failed: ${error.message}');

// For large data (JSON responses, maps)
AppLogger.data('API', 'Response body', jsonResponse);

// For debugging with stack trace
AppLogger.trace('UI', 'Button pressed');

// Built-in API logging (already integrated in NetworkApiServices)
AppLogger.apiRequest('POST', url.path, headers);
AppLogger.apiResponse('POST', url.path, response.statusCode, response.body);
```

---

### Mistake 2: Inconsistent connectivity checks (FIXED)

**Old problem**: Some methods used `apiHandlerWithConnectivity`, others used plain `apiHandler`.

**Current fix**: `ApiCallHandler.call()` now handles connectivity, loading state, 401 refresh, and typed error routing in a single static method. There is no separate `apiHandler` vs `apiHandlerWithConnectivity` — it's all unified.

```dart
// GOOD — the ONLY way to call APIs now
await ApiCallHandler.call(
  apiCall: () => _repo.updateProfile(data),
  isLoading: isLoading,
  errorMessage: errorMessage,
  onSuccess: (response) { /* handle ApiResponse */ },
  onError: (error) { /* error is AppException */ },
);
```

**What `ApiCallHandler.call()` does automatically**:
1. Checks connectivity via `NetworkManager`
2. Sets `isLoading.value = true`
3. Clears `errorMessage`
4. Calls `apiCall()`
5. On 401 → attempts token refresh → retries once → force logout if refresh fails
6. Catches all `AppException` subtypes
7. Sets `isLoading.value = false` in `finally`

---

### Mistake 3: Mock implementations left in production API service

```dart
// BAD - Found in profile_setup_api_service.dart
Future<void> deletePhoto({...}) async {
  await _apiHandler.apiHandlerWithConnectivity(
    apiCall: () async {
      // MOCK: Simulate photo deletion
      await Future.delayed(const Duration(milliseconds: 500));
      return {'deleted_url': photoUrl, 'success': true};
    },
    ...
  );
}

Future<Map<String, dynamic>> checkVerificationStatus() async {
  // MOCK: Return mock verification status
  await Future.delayed(const Duration(milliseconds: 500));
  return { 'selfie_verified': false, 'document_verified': false };
}
```

**Rule**: Never leave mock/stub implementations in production API service files. If an endpoint is not ready, throw `UnimplementedError` with a clear message, or gate it behind a feature flag.

```dart
// GOOD - clearly unimplemented
Future<Map<String, dynamic>> checkVerificationStatus() async {
  // TODO(backend): Waiting for GET /api/v1/verification/status endpoint
  throw UnimplementedError('checkVerificationStatus not yet available');
}
```

---

### Mistake 4: Inconsistent debouncing - some API calls debounced, most are not

```dart
// In profile_setup_api_service.dart:
// Debouncers declared but NEVER used for most methods
final AppDebouncer _updateProfileDebouncer = AppDebouncer(milliseconds: 30000);

// updateProfileDetails - NO debouncing
// updatePhotos - NO debouncing
// deletePhotoByPublicId - NO debouncing
// reorderPhotosByPublicIds - NO debouncing
// getProfileMe - NO debouncing
// submitStep - NO debouncing
```

**Rule**: Every mutating API call (POST/PUT/PATCH/DELETE) MUST be debounced. Read-only calls (GET) should use debouncing only if they are triggered by user interaction (e.g., search).

```dart
// GOOD - debounced write operations
Future<void> updateProfileDetails({...}) async {
  _updateProfileDebouncer.run(() async {
    await _apiHandler.apiHandlerWithConnectivity(...);
  });
}

// GOOD - GET triggered by pull-to-refresh, no debounce needed
Future<void> getProfileMe({...}) async {
  await _apiHandler.apiHandlerWithConnectivity(...);
}
```

---

### Mistake 5: Repo bypasses its own abstraction (FIXED)

**Old problem**: `reorderPhotosOnServer()` manually built `http.Request` instead of using `NetworkApiServices`.

**Current fix**: All repo methods now use `_network.sendRequest()` or `_network.multipartRequest()`. Never build raw HTTP requests.

```dart
// GOOD — current pattern from profile_setup_repo_impl.dart
@override
Future<ApiResponse> reorderPhotoOnServer(String photoId, int toPosition) async {
  return await _network.sendRequest(
    url: AppUrls.reorderPhotos,
    method: HttpMethod.patch,
    body: {
      'photoId': photoId,
      'toPosition': toPosition.toString(),
    },
  );
}

// GOOD — file upload uses multipartRequest
@override
Future<ApiResponse> uploadPhotosToServer(List<File> photos, Map<String, String> fields) async {
  return await _network.multipartRequest(
    url: AppUrls.profilePhotos,
    method: HttpMethod.post,
    files: photos,
    fileFieldName: 'photos',
    fields: fields,
  );
}
```

---

### Mistake 6: Body serialization inconsistency in NetworkApiServices (FIXED)

**Old problem**: POST sent `bodyFields` (form-urlencoded) while PATCH sent `jsonEncode` (JSON). This forced ugly `.toString()` hacks.

**Current fix**: `NetworkApiServices.sendRequest()` now uses `jsonEncode(body)` for ALL methods (POST, PUT, PATCH, DELETE). The `Content-Type: application/json` header is set automatically.

```dart
// In the current NetworkApiServices.sendRequest():
// ALL methods use jsonEncode consistently:
case HttpMethod.post:
  response = await http.post(url, headers: headers, body: body != null ? jsonEncode(body) : null);
case HttpMethod.patch:
  response = await http.patch(url, headers: headers, body: body != null ? jsonEncode(body) : null);
case HttpMethod.delete:
  response = await http.delete(url, headers: headers, body: body != null ? jsonEncode(body) : null);
```

**Rule**: Repo methods pass `Map<String, dynamic>` as body. `NetworkApiServices` handles serialization. Never manually `jsonEncode` in the repo.

---

### Mistake 7: Hardcoded onboarding step metadata in API service

```dart
// BAD - Found in profile_setup_api_service.dart
Future<void> updatePhotos({...}) async {
  final onboardingData = {
    'nextstep': 9,                              // Hardcoded magic number
    'currentScreenSlug': 'upload_photos_screen', // Hardcoded string
    'isComplete': false,                         // Hardcoded
  };
  ...
}
```

**Rule**: Step metadata must come from the state service or be passed as parameters. Never hardcode step numbers or screen slugs in the API service layer.

```dart
// GOOD - pass from controller/service
Future<void> updatePhotos({
  required List<File> newPhotos,
  required Map<String, dynamic> onboardingMeta, // Passed in, not hardcoded
  ...
}) async { ... }
```

---

### Mistake 8: Controller creates new repo instances instead of using injected one

```dart
// BAD - Found in profile_setup_controller.dart clearDraft()
ProfileSetupRepoImpl().clearDraft(); // Creates a NEW instance
// repo.clearDraft(); // The injected repo is commented out!
```

**Rule**: Always use the injected dependency. Never instantiate a new instance of a class that is already provided via DI.

---

### Mistake 9: Navigation uses force-unwrap on nullable context

```dart
// BAD - Found in profile_setup_service.dart
void navigateToStep(int step, {BuildContext? context}) {
  try {
    AppGoRouter.router.push(route);
  } catch (e) {
    ProfileSetupErrorHandler.handleNavigationError(context!); // CRASH if context is null
  }
}
```

**Rule**: Never force-unwrap `context!`. Always guard with null check or make the parameter required.

```dart
// GOOD
if (context != null && context.mounted) {
  ProfileSetupErrorHandler.handleNavigationError(context);
}
```

---

### Mistake 10: Service layer directly accesses singleton instead of receiving dependency

```dart
// BAD - Found in profile_setup_service.dart
class ProfileSetupService {
  final ProfileSetupApiService _apiService = ProfileSetupApiService(); // Direct singleton access
  final ProfileSetupStateService _stateService = ProfileSetupStateService.instance;
}
```

**Rule**: Services should receive dependencies through constructor or DI, not by directly accessing singletons. This makes testing impossible without modifying production code.

```dart
// GOOD - injectable
class ProfileSetupService {
  final ProfileSetupApiService _apiService;
  final ProfileSetupStateService _stateService;

  ProfileSetupService({
    ProfileSetupApiService? apiService,
    ProfileSetupStateService? stateService,
  })  : _apiService = apiService ?? ProfileSetupApiService(),
        _stateService = stateService ?? ProfileSetupStateService.instance;
}
```

---

### Mistake 11: No token refresh / 401 handling in API layer (FIXED)

**Old problem**: `apiHandler` had no 401 detection. Each feature had to handle session expiry manually.

**Current fix**: `ApiCallHandler.call()` now catches `UnauthorizedException`, attempts a token refresh via `_attemptTokenRefresh()`, retries the original call once, and calls `_forceLogout()` if refresh fails. Every feature gets this for free.

```dart
// Current implementation in ApiCallHandler.call():
} on UnauthorizedException catch (_) {
  final refreshed = await _attemptTokenRefresh();
  if (refreshed) {
    // Retry original call once
    final retryResponse = await apiCall();
    if (retryResponse.isSuccess) {
      onSuccess(retryResponse);
    } else {
      onError?.call(ApiStatusFalseException(retryResponse.message));
    }
  } else {
    // Refresh failed — force logout
    onError?.call(const TokenRefreshException());
    await _forceLogout();
  }
}
```

**Rule**: Features handle `TokenRefreshException` in their error handler to navigate to login. See `AuthErrorHandler.handleAppException()` for the pattern.

---

### Mistake 12: `context.mounted` not checked before using context after async gaps

```dart
// BAD - Found in multiple places in profile_setup_controller.dart
await authController.authentication();
// No mounted check before using context after await

// Also in nextStep():
await _apiService.submitStep(...);
draft.update((d) => d?.currentStep = step + 1);
await saveDraft(context: context); // context may be stale
```

**Rule**: After every `await`, check `if (!context.mounted) return;` before using `context` for navigation, snackbars, or dialogs.

---

## 5. Correct Patterns (Reference Implementation)

### 5.1 Repository Layer

Two patterns exist depending on complexity:

**Pattern A: Plain Dart class (Auth — no abstract interface needed)**
```dart
// repo/auth_repo.dart — plain class, no GetX, no state
class AuthenticationRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> registerPhone(String phone) async {
    return await _network.sendRequest(
      url: AppUrls.register,
      method: HttpMethod.post,
      body: {'phone': "+91$phone"},
    );
  }

  Future<ApiResponse> verifyPhone(String phone, String otp) async {
    return await _network.sendRequest(
      url: AppUrls.verifyPhone,
      method: HttpMethod.post,
      body: {'phone': "+91$phone", 'otp': otp},
    );
  }

  Future<ApiResponse> refreshToken() async {
    return await _network.sendRequest(
      url: AppUrls.refreshToken,
      method: HttpMethod.post,
      useRefreshToken: true,
    );
  }
}
```

**Pattern B: Abstract + Impl (Onboarding — has local storage + network)**
```dart
// repo/profile_setup_repo.dart — abstract interface
abstract class ProfileSetupRepo {
  Future<void> saveDraft(Map<String, dynamic> json);
  Future<Map<String, dynamic>?> loadDraft();
  Future<ApiResponse> getProfileMeFromServer();
  Future<ApiResponse> updateProfileOnServer(Map<String, dynamic> profileData);
  Future<ApiResponse> deletePhotoFromServer(String publicId);
  Future<ApiResponse> reorderPhotoOnServer(String photoId, int toPosition);
  Future<ApiResponse> uploadPhotosToServer(List<File> photos, Map<String, String> fields);
}

// repo/profile_setup_repo_impl.dart — concrete, plain Dart class
class ProfileSetupRepoImpl implements ProfileSetupRepo {
  final AppLocalStorage _storage = AppLocalStorage.instance();
  final NetworkApiServices _network = NetworkApiServices();

  @override
  Future<ApiResponse> reorderPhotoOnServer(String photoId, int toPosition) async {
    return await _network.sendRequest(
      url: AppUrls.reorderPhotos,
      method: HttpMethod.patch,
      body: {'photoId': photoId, 'toPosition': toPosition.toString()},
    );
  }

  @override
  Future<ApiResponse> uploadPhotosToServer(List<File> photos, Map<String, String> fields) async {
    return await _network.multipartRequest(
      url: AppUrls.profilePhotos,
      method: HttpMethod.post,
      files: photos,
      fileFieldName: 'photos',
      fields: fields,
    );
  }
}
```

**Key rules for Repo**:
- Plain Dart class — NO GetX, NO state, NO navigation
- All methods return `Future<ApiResponse>` (not `Map<String, dynamic>`)
- Always use `_network.sendRequest()` for JSON calls, `_network.multipartRequest()` for file uploads
- Body is `Map<String, dynamic>` — `NetworkApiServices` handles `jsonEncode`
- Repo does NOT access `UserPreferences` for headers (NetworkApiServices does that)
- Let exceptions propagate up — do NOT catch and re-wrap

---

### 5.2 API Service Layer

API Service is a `GetxService` that resolves the repo via `Get.find()` in `onInit()`. It owns a debouncer and delegates all calls to `ApiCallHandler.call()`.

```dart
// Real example from auth_api_service.dart
class AuthApiService extends GetxService {
  late final AuthenticationRepository _authRepo;
  final AppDebouncer _debouncer = AppDebouncer(milliseconds: 100);

  @override
  void onInit() {
    super.onInit();
    _authRepo = Get.find<AuthenticationRepository>();
  }

  // READ — no debounce (called once at startup)
  Future<ApiResponse> checkAuthStatus() async {
    return await _authRepo.refreshToken();
  }

  // WRITE — debounced
  void registerPhone({
    required String phone,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) {
    _debouncer.run(() async {
      await ApiCallHandler.call(
        apiCall: () => _authRepo.registerPhone(phone),
        isLoading: isLoading,
        errorMessage: errorMessage,
        onSuccess: onSuccess,
        onError: onError,
      );
    });
  }
}
```

```dart
// Real example from profile_setup_api_service.dart
class ProfileSetupApiService extends GetxService {
  late final ProfileSetupRepo _repo;
  final AppDebouncer _mutationDebouncer = AppDebouncer(milliseconds: 100);

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<ProfileSetupRepo>();
  }

  // READ — no debounce, direct await
  Future<void> getProfileMe({
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) async {
    await ApiCallHandler.call(
      apiCall: () => _repo.getProfileMeFromServer(),
      isLoading: isLoading,
      errorMessage: errorMessage,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  // WRITE — debounced
  void reorderPhotoByPublicId({
    required String photoId,
    required int toPosition,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) {
    _mutationDebouncer.run(() async {
      await ApiCallHandler.call(
        apiCall: () => _repo.reorderPhotoOnServer(photoId, toPosition),
        isLoading: isLoading,
        errorMessage: errorMessage,
        onSuccess: onSuccess,
        onError: onError,
      );
    });
  }

  // LOCAL — no ApiCallHandler needed for local storage
  Future<void> saveDraft({
    required Map<String, dynamic> draftData,
    required RxBool isSaving,
    required RxString errorMessage,
    required Function() onSuccess,
  }) async {
    isSaving.value = true;
    try {
      await _repo.saveDraft(draftData);
      onSuccess();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isSaving.value = false;
    }
  }
}
```

**Key rules for API Service**:
- Extends `GetxService` (not `GetxController`)
- Resolves repo via `Get.find()` in `onInit()`
- Standard method signature: `isLoading`, `errorMessage`, `onSuccess`, `onError?` — **NO `context`**
- `onSuccess` receives `ApiResponse` (typed), `onError` receives `AppException` (typed)
- All mutating calls (POST/PUT/PATCH/DELETE) are debounced via `_debouncer.run()`
- GET calls are NOT debounced
- Local storage calls do NOT go through `ApiCallHandler`
- No business logic — just wiring between `ApiCallHandler` and Repo
- No hardcoded metadata — receive everything as parameters

---

### 5.3 Service Layer (Business Logic)

Service is a `GetxService` that resolves dependencies via `Get.find()` in `onInit()`. It handles business logic, data transformation, response parsing, and navigation.

```dart
// Real example from auth_service.dart — focused service
class AuthService extends GetxService {
  static AuthService get instance => Get.find();

  /// Unified navigation logic after successful auth
  Future<void> handlePostAuthNavigation(User user, BuildContext context) async {
    if (user.isEmailVerified == true) {
      if (user.onboarding?.isComplete == true) {
        if (context.mounted) {
          context.pushReplacement(AppRoutes.bottomNavigationBar);
        }
      } else {
        ProfileSetupDependencies.init();
        final profileSetupController = ProfileSetupController.instance;
        await profileSetupController.initAndMaybeNavigate();
      }
    } else {
      if (context.mounted) {
        context.pushReplacement(AppRoutes.authEntry, extra: AuthEntryMode.email);
      }
    }
  }

  bool needsEmailVerification(User user) =>
      user.isPhoneVerified == true && user.isEmailVerified != true;
}
```

```dart
// Real example from profile_setup_service.dart — handles API delegation + response parsing
class ProfileSetupService extends GetxService {
  late final ProfileSetupApiService _apiService;
  late final ProfileSetupStateService _stateService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ProfileSetupApiService>();
    _stateService = Get.find<ProfileSetupStateService>();
  }

  // RESPONSE PARSING — extract typed data from ApiResponse
  List<ProfilePhoto> _extractUploadedPhotos(ApiResponse response) {
    final data = response.data;
    if (data is! Map<String, dynamic>) return <ProfilePhoto>[];
    final photos = data['user']?['photos'];
    if (photos is List) {
      return photos
          .whereType<Map>()
          .map((e) => ProfilePhoto.fromJson(Map<String, dynamic>.from(e)))
          .where((p) => p.url.isNotEmpty)
          .toList();
    }
    return <ProfilePhoto>[];
  }

  // API DELEGATION — wraps API call with error handling
  void handleReorderPhotoByPublicId({
    required String photoId,
    required int toPosition,
    required BuildContext context,
    required Function(List<ProfilePhoto> photos) onSuccess,
    Function(AppException error)? onError,
  }) {
    _apiService.reorderPhotoByPublicId(
      photoId: photoId,
      toPosition: toPosition,
      isLoading: _stateService.isUploading,
      errorMessage: _stateService.errorMessage,
      onSuccess: (response) {
        final updatedPhotos = _extractUploadedPhotos(response);
        onSuccess(updatedPhotos);
      },
      onError: (error) {
        if (context.mounted) {
          ProfileSetupErrorHandler.handlePhotoError(context, specificError: error.message);
        }
        onError?.call(error);
      },
    );
  }

  // PAYLOAD PREPARATION — transform draft to API shape
  Map<String, dynamic> prepareProfileData(ProfileSetupModel draft) {
    return {
      'profile': {
        'nickname': draft.name,
        'dob': draft.dob?.toIso8601String().split('T')[0],
        'gender': draft.identity,
      },
      'attributes': { 'interests': draft.interests },
      'discovery': {
        'distanceRange': draft.distanceKm,
        'ageRange': { 'min': draft.ageMin, 'max': draft.ageMax },
        'showMeGender': [draft.interestedIn],
        'relationshipGoal': draft.relationshipGoal,
      },
    };
  }

  // NAVIGATION
  void navigateToStep(int step, {BuildContext? context}) {
    AppGoRouter.router.push('/profile/step/$step');
  }

  void navigateToHome({BuildContext? context}) {
    AppGoRouter.router.go(AppRoutes.bottomNavigationBar);
  }
}
```

**Key rules for Service**:
- Extends `GetxService`, resolves dependencies via `Get.find()` in `onInit()`
- Contains: response parsing, payload preparation, API delegation, navigation
- Does NOT directly call `ApiCallHandler` — that's the API Service's job
- Does NOT manage loading states — passes `_stateService.isXxx` to API Service
- Always checks `context.mounted` before navigation/snackbars
- `onSuccess` callback returns **typed data** (e.g., `List<ProfilePhoto>`), not raw `ApiResponse`

---

### 5.4 State Service

```dart
// Real example from auth_state_service.dart
class AuthStateService extends GetxService {
  static AuthStateService get instance => Get.find();

  // Current auth flow state
  final Rx<AuthEntryMode> currentMode = AuthEntryMode.phone.obs;
  final RxString currentContact = ''.obs;

  // Auth status tracking
  final RxBool isPhoneVerified = false.obs;
  final RxBool isEmailVerified = false.obs;
  final RxBool isOnboardingComplete = false.obs;
  final RxBool isLoggingOut = false.obs;

  // Loading states — one per distinct operation type
  final RxBool isAuthenticating = false.obs;
  final RxBool isRegistering = false.obs;
  final RxBool isVerifying = false.obs;

  // Error handling
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  /// Update auth state based on user data
  void updateAuthState(User user) {
    isPhoneVerified.value = user.isPhoneVerified ?? false;
    isEmailVerified.value = user.isEmailVerified ?? false;
    isOnboardingComplete.value = user.onboarding?.isComplete ?? false;
    clearError();
  }

  void setAuthMode(AuthEntryMode mode, String contact) {
    currentMode.value = mode;
    currentContact.value = contact;
  }

  void setError(String error) {
    errorMessage.value = error;
    hasError.value = true;
  }

  void clearError() {
    errorMessage.value = '';
    hasError.value = false;
  }

  void reset() {
    currentMode.value = AuthEntryMode.phone;
    currentContact.value = '';
    isPhoneVerified.value = false;
    isLoggingOut.value = false;
    isEmailVerified.value = false;
    isOnboardingComplete.value = false;
    isAuthenticating.value = false;
    isRegistering.value = false;
    isVerifying.value = false;
    clearError();
  }

  // Computed getters
  bool get canProceedToOnboarding => isPhoneVerified.value && isEmailVerified.value;
  bool get canGoToHome => isPhoneVerified.value && isEmailVerified.value && isOnboardingComplete.value;
}
```

**Key rules for State Service**:
- Extends `GetxService` (not `GetxController`)
- Has a static `instance` getter: `static T get instance => Get.find();`
- Separate `RxBool` for each operation type (isRegistering, isVerifying, isUploading, isSubmitting, isLoggingOut, etc.)
- Has `reset()` that clears everything back to defaults
- Has `setError()` / `clearError()` for unified error state
- Computed getters for derived state (`canProceedToOnboarding`, `canGoToHome`)
- No business logic — only state storage and computed getters

---

### 5.5 Controller

```dart
// Real example from auth_controller.dart
class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // Dependencies — resolved in onInit via Get.find
  late final AuthApiService _apiService;
  late final AuthService _authService;
  late final AuthStateService _stateService;
  late final UserController _userController;
  final UserPreferences _prefs = UserPreferences();

  // Text Controllers
  final phoneController = TextEditingController(text: "9406945040");
  final emailController = TextEditingController();

  // OTP State
  final RxString otp = ''.obs;
  final int otpLength = 6;
  final RxInt resendCooldown = 0.obs;
  Timer? _resendTimer;

  // Delegate Getters — UI uses these directly
  RxBool get isRegistering => _stateService.isRegistering;
  RxBool get isVerifying => _stateService.isVerifying;
  RxBool get isLoggingOut => _stateService.isLoggingOut;
  RxString get errorMessage => _stateService.errorMessage;

  // Computed
  bool get isOtpComplete => otp.value.length == otpLength;
  bool get canResend => resendCooldown.value == 0;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<AuthApiService>();
    _authService = Get.find<AuthService>();
    _stateService = Get.find<AuthStateService>();
    _userController = Get.find<UserController>();
  }

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    _resendTimer?.cancel();
    super.onClose();
  }

  // The controller pattern: validate → prevent duplicate → call API → handle callbacks
  Future<void> registerPhone(String phone, BuildContext context) async {
    // Step 1: Validate
    final validationError = AuthValidator.validatePhone(phone);
    if (validationError != null) {
      if (context.mounted) AuthErrorHandler.handleAuthError(validationError, context);
      return;
    }

    // Step 2: Prevent duplicate submission
    if (isRegistering.value) return;

    // Step 3: Call API
    _apiService.registerPhone(
      phone: phone,
      isLoading: _stateService.isRegistering,
      errorMessage: _stateService.errorMessage,
      onSuccess: (response) {
        if (!context.mounted) return;
        AuthErrorHandler.handleAuthSuccess(context, message: response.message.isNotEmpty ? response.message : 'OTP sent');
        _stateService.setAuthMode(AuthEntryMode.phone, phone);
        _startResendCooldown();
        context.push(AppRoutes.otpVerify, extra: {'mode': AuthEntryMode.phone, 'data': phone});
      },
      onError: (error) {
        AppLogger.e('AuthController', 'Phone registration failed', error);
        if (context.mounted) AuthErrorHandler.handleAppException(error, context);
      },
    );
  }

  // Logout — even on API failure, clear local data and navigate out
  Future<void> logout(BuildContext context) async {
    if (isLoggingOut.value) return;
    _apiService.logout(
      isLoading: _stateService.isLoggingOut,
      errorMessage: _stateService.errorMessage,
      onSuccess: (response) async {
        await _clearAuthData();
        _stateService.reset();
        _userController.clearUserRecord();
        _resetFormFields();
        if (context.mounted) AppGoRouter.router.go(AppRoutes.welcomeScreen);
      },
      onError: (error) async {
        // Even if logout API fails, still clear locally
        AppLogger.w('AuthController', 'Logout API failed, clearing locally: ${error.message}');
        await _clearAuthData();
        _stateService.reset();
        if (context.mounted) AppGoRouter.router.go(AppRoutes.welcomeScreen);
      },
    );
  }
}
```

**Key rules for Controller**:
- Extends `GetxController`, has `static T get instance => Get.find();`
- Resolves ALL dependencies in `onInit()` using `Get.find()` — never in field initializers
- Delegate getters expose state to UI: `RxBool get isRegistering => _stateService.isRegistering;`
- The pattern for every action: **validate → prevent duplicate → call API → handle callbacks**
- `onSuccess` callback: check `context.mounted`, show success, navigate
- `onError` callback: log with `AppLogger`, check `context.mounted`, show error via ErrorHandler
- `onClose()` disposes text controllers, cancels timers
- Controller does NOT parse responses — that's the Service's job
- Controller does NOT build payloads — that's the Service's job

---

### 5.6 Validator

```dart
// Real example from auth_validator.dart
class AuthValidator {
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) return 'Phone number is required';
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length != 10) return 'Phone number must be 10 digits';
    if (!cleanPhone.startsWith(RegExp(r'[4-9]'))) return 'Please enter a valid mobile number';
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) return 'Please enter a valid email address';
    return null;
  }

  static String? validateOtp(String? otp, {int length = 6}) {
    if (otp == null || otp.isEmpty) return 'OTP is required';
    if (otp.length != length) return 'OTP must be $length digits';
    if (!RegExp(r'^\d+$').hasMatch(otp)) return 'OTP must contain only digits';
    return null;
  }

  static String? validateAuthStep(User user) {
    if (!(user.isPhoneVerified ?? false)) return 'Phone number must be verified first';
    if (!(user.isEmailVerified ?? false)) return 'Email address must be verified';
    if (!(user.onboarding?.isComplete ?? false)) return 'Please complete your profile setup';
    return null;
  }
}
```

**Key rules for Validator**:
- All methods are `static`
- Return `String?` — `null` means valid, non-null is the error message
- Pure functions — no side effects, no context, no snackbars, no state
- The CALLER decides what to do with the error string
- Use for: input format, business rules, completeness checks

---

### 5.7 Error Handler

The error handler now works with typed `AppException` instead of raw dynamic errors. Since `NetworkApiServices` throws typed exceptions and `ApiCallHandler` catches them, the error handler receives clean typed errors.

```dart
// Real example from auth_error_handler.dart
class AuthErrorHandler {
  /// Handle typed AppException — the primary error handler
  static void handleAppException(AppException error, BuildContext context) {
    if (!context.mounted) return;

    // Special case: session expired — redirect to login
    if (error is TokenRefreshException || error is UnauthorizedException) {
      AppSnackBar.showSnackbar(
        context: context,
        title: 'Session Expired',
        message: 'Please login again',
        type: SnackbarType.error,
      );
      AppGoRouter.router.go(AppRoutes.welcomeScreen);
      return;
    }

    // Default: show error.message (already user-friendly from AppException subclasses)
    AppSnackBar.showSnackbar(
      context: context,
      title: 'Error',
      message: error.message,
      type: SnackbarType.error,
    );
  }

  /// Handle validation error (string from validator)
  static void handleAuthError(String error, BuildContext context) {
    if (!context.mounted) return;
    AppSnackBar.showSnackbar(
      context: context,
      title: 'Error',
      message: error,
      type: SnackbarType.error,
    );
  }

  /// Handle success
  static void handleAuthSuccess(BuildContext context, {String? message}) {
    if (!context.mounted) return;
    AppSnackBar.showSnackbar(
      context: context,
      title: 'Success',
      message: message ?? 'Operation successful',
      type: SnackbarType.success,
    );
  }
}
```

**Key rules for Error Handler**:
- ALWAYS check `context.mounted` before showing UI
- Two error methods: `handleAppException(AppException)` for API errors, `handleAuthError(String)` for validation strings
- Handle `TokenRefreshException` / `UnauthorizedException` specially — navigate to login
- No need for `_getErrorMessage()` parsing — `AppException.message` is already user-friendly
- Each `AppException` subclass has a default message (e.g., `NetworkException` → "Please check your internet connection")

### AppException Hierarchy (for reference)

| Exception | Status | Default Message |
|---|---|---|
| `NetworkException` | — | Please check your internet connection |
| `TimeoutException` | — | Request timed out. Please try again |
| `BadRequestException` | 400 | (from server) |
| `UnauthorizedException` | 401 | Session expired. Please login again |
| `ForbiddenException` | 403 | Access denied |
| `NotFoundException` | 404 | Resource not found |
| `ConflictException` | 409 | (from server) |
| `ValidationException` | 422 | (from server, with `errors` map) |
| `RateLimitException` | 429 | Too many requests. Please wait and try again |
| `ServerException` | 500 | Server error. Please try again later |
| `ApiStatusFalseException` | 200 | (from server — HTTP OK but `success: false`) |
| `TokenRefreshException` | — | Unable to refresh session |

---

### 5.8 Dependency Injection

```dart
// Real example from auth_dependencies.dart
class AuthDependencies {
  static bool _isInitialized = false;

  static void init() {
    if (_isInitialized) return;

    // Order: repo → state → services → controllers
    // 1. Repository (plain Dart class, not GetxService)
    Get.put<AuthenticationRepository>(AuthenticationRepository(), permanent: true);

    // 2. State
    Get.put<AuthStateService>(AuthStateService(), permanent: true);

    // 3. Services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<AuthApiService>(AuthApiService(), permanent: true);

    // 4. Controllers (last — they resolve deps in onInit)
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);

    _isInitialized = true;
  }

  static void dispose() {
    Get.delete<AuthController>();
    Get.delete<UserController>();
    _isInitialized = false;
  }
}
```

**Key DI rules**:
- Registration order: **Repo → State → Services → Controllers**
- Controllers are registered LAST because they call `Get.find()` in `onInit()`
- All registrations use `permanent: true`
- `_isInitialized` guard prevents double registration
- `dispose()` only deletes controllers — services stay alive
- Repo is registered as its concrete type (or abstract type if using interface pattern)

---

## 6. Security Rules

### Rule S1: Validate before every API call
```dart
// Real pattern from auth_controller.dart
final validationError = AuthValidator.validatePhone(phone);
if (validationError != null) {
  if (context.mounted) AuthErrorHandler.handleAuthError(validationError, context);
  return; // STOP — do not call API
}
if (isRegistering.value) return; // Prevent duplicate
```

### Rule S2: Never log sensitive data
```dart
// BAD
print('Token: ${token}');
print('User data: ${user.toJson()}');

// GOOD — AppLogger is gated behind kDebugMode, uses developer.log
AppLogger.d('Auth', 'Registration initiated for phone');
AppLogger.apiResponse('POST', url.path, response.statusCode); // Status only
```

### Rule S3: Never hardcode API keys or secrets
```dart
// BAD
final apiKey = 'sk_live_abc123';

// GOOD
final apiKey = dotenv.env['API_KEY'];
```

### Rule S4: Sanitize user input before sending to API
```dart
// Real pattern from auth_controller.dart
email: email.trim().toLowerCase(),
```

### Rule S5: File upload validation
```dart
static String? validateFile(File file, {int maxSizeMB = 10}) {
  if (!file.existsSync()) return 'File not found';
  final sizeInMB = file.lengthSync() / (1024 * 1024);
  if (sizeInMB > maxSizeMB) return 'File must be less than ${maxSizeMB}MB';
  final ext = file.path.split('.').last.toLowerCase();
  final allowed = ['jpg', 'jpeg', 'png', 'heic', 'webp'];
  if (!allowed.contains(ext)) return 'Unsupported file format';
  return null;
}
```

### Rule S6: Prevent duplicate API submissions
```dart
// Real pattern — check loading state before calling API
if (isRegistering.value) return;
if (isLoggingOut.value) return;
if (!isOtpComplete) return;
```

---

## 7. Performance Rules

### Rule P1: Debounce all mutating API calls
Every POST, PUT, PATCH, DELETE must go through `_debouncer.run()`. See section 5.2.

### Rule P2: Use correct loading state per operation
```dart
// BAD — one loading flag for everything
isLoading.value = true;

// GOOD — specific flags per operation (from auth_state_service.dart)
isRegistering.value = true;  // Phone/email registration
isVerifying.value = true;    // OTP verification
isLoggingOut.value = true;   // Logout
isUploading.value = true;    // File upload (from onboarding)
isSubmitting.value = true;   // Form submission
isSaving.value = true;       // Local draft save
isLoading.value = true;      // Initial data fetch (GET)
```

### Rule P3: Optimistic UI updates with rollback
```dart
// Real pattern from profile_setup_controller.dart — photo reorder
final previousOrder = List<PhotoTile>.from(photoTiles);

// 1. Apply change locally first (optimistic)
final item = photoTiles.removeAt(oldIndex);
photoTiles.insert(newIndex, item);

// 2. Get the moved photo's publicId and new position
final movedPhotoId = item.publicId;
final uploadedPhotos = photoTiles.where((t) => t.isUploaded && t.publicId != null).toList();
final newPosition = uploadedPhotos.indexWhere((t) => t.publicId == movedPhotoId);

// 3. Call API with single item reorder
_service.handleReorderPhotoByPublicId(
  photoId: movedPhotoId,
  toPosition: newPosition,
  context: context,
  onSuccess: (updatedPhotos) async {
    draft.update((d) { d?.photos = updatedPhotos; });
  },
  onError: (error) {
    photoTiles.assignAll(previousOrder); // Rollback on failure
  },
);
```

### Rule P4: Cancel pending operations on dispose
```dart
// Real pattern from auth_controller.dart
@override
void onClose() {
  phoneController.dispose();
  emailController.dispose();
  _resendTimer?.cancel();
  super.onClose();
}
```

---

## 8. Error Handling Rules

### Rule E1: Never swallow errors silently
```dart
// BAD
try { await apiCall(); } catch (e) { /* silent */ }

// GOOD — log + show to user
onError: (error) {
  AppLogger.e('Feature', 'Operation failed', error);
  if (context.mounted) FeatureErrorHandler.handleAppException(error, context);
},
```

### Rule E2: Let repo exceptions propagate
```dart
// BAD — repo catches and re-wraps
Future<ApiResponse> getItems() async {
  try { return await _network.sendRequest(...); }
  catch (e) { throw Exception('Failed: $e'); } // Wraps typed exception
}

// GOOD — let NetworkApiServices typed exceptions propagate
Future<ApiResponse> getItems() async {
  return await _network.sendRequest(...);
  // NetworkApiServices already throws AppException subtypes
}
```

### Rule E3: 401 is handled at ApiCallHandler level (automatic)
`ApiCallHandler.call()` catches `UnauthorizedException`, refreshes token, retries once. No feature code needed. Features only handle `TokenRefreshException` in their error handler to navigate to login.

### Rule E4: Always check `context.mounted` after async gaps
```dart
// Real pattern from auth_controller.dart
onSuccess: (response) {
  if (!context.mounted) return; // CHECK before using context
  AuthErrorHandler.handleAuthSuccess(context, message: 'OTP sent');
  context.push(AppRoutes.otpVerify, extra: {...});
},

// Also in logout — after await
await _clearAuthData();
if (context.mounted) AppGoRouter.router.go(AppRoutes.welcomeScreen);
```

### Rule E5: Logout must succeed even if API fails
```dart
// Real pattern from auth_controller.dart
onError: (error) async {
  // Even if logout API fails, clear local data and navigate out
  AppLogger.w('Auth', 'Logout API failed, clearing locally');
  await _clearAuthData();
  _stateService.reset();
  if (context.mounted) AppGoRouter.router.go(AppRoutes.welcomeScreen);
},
```

---

## 9. Data Flow Rules

### Rule D1: Response parsing belongs in the Service layer
```dart
// BAD — parsing in controller
onSuccess: (response) {
  final data = response.data as Map<String, dynamic>;
  final photos = data['user']?['photos'];
  // ... inline parsing
}

// GOOD — Service handles parsing, returns typed data
// In profile_setup_service.dart:
List<ProfilePhoto> _extractUploadedPhotos(ApiResponse response) {
  final data = response.data;
  if (data is! Map<String, dynamic>) return <ProfilePhoto>[];
  final photos = data['user']?['photos'];
  if (photos is List) {
    return photos.whereType<Map>()
        .map((e) => ProfilePhoto.fromJson(Map<String, dynamic>.from(e)))
        .where((p) => p.url.isNotEmpty)
        .toList();
  }
  return <ProfilePhoto>[];
}

// Service wraps the API call and returns typed data to controller:
onSuccess: (response) {
  final updatedPhotos = _extractUploadedPhotos(response);
  onSuccess(updatedPhotos); // Controller gets List<ProfilePhoto>
},
```

### Rule D2: Payload preparation belongs in the Service layer
```dart
// Real pattern from profile_setup_service.dart
Map<String, dynamic> prepareProfileData(ProfileSetupModel draft) {
  return {
    'profile': {
      'nickname': draft.name,
      'dob': draft.dob?.toIso8601String().split('T')[0],
      'gender': draft.identity,
    },
    'attributes': { 'interests': draft.interests },
    'discovery': {
      'distanceRange': draft.distanceKm,
      'ageRange': { 'min': draft.ageMin, 'max': draft.ageMax },
      'showMeGender': [draft.interestedIn],
      'relationshipGoal': draft.relationshipGoal,
    },
  };
}
```

### Rule D3: Model classes must have `fromJson` and `toJson`
```dart
class ProfilePhoto {
  final String url;
  final String? publicId;

  ProfilePhoto({required this.url, this.publicId});

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) {
    return ProfilePhoto(
      url: json['url'] as String? ?? '',
      publicId: json['public_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => { 'url': url, 'public_id': publicId };
}
```

### Rule D4: Auth response handling pattern
```dart
// Real pattern from auth_controller.dart — _handleAuthSuccess
void _handleAuthSuccess(Map<String, dynamic> data, BuildContext context) {
  // 1. Save tokens
  final accessToken = data['accessToken'];
  final refreshToken = data['refreshToken'];
  if (accessToken != null) _prefs.setToken(accessToken);
  if (refreshToken != null) _prefs.setRefreshToken(refreshToken);

  // 2. Save user ID
  final userId = data['user']?['profile']['id'];
  if (userId != null) _prefs.setUserId(userId);

  // 3. Parse and save user
  final user = User.fromJson(data['user']);
  _userController.saveUserRecord(user);
  _stateService.updateAuthState(user);

  // 4. Navigate based on completion state
  if (context.mounted) _authService.handlePostAuthNavigation(user, context);
}
```

---

## 10. Checklist for New Feature API Integration

Use this checklist when building a new feature module:

### Setup
- [ ] Create directory structure per section 3
- [ ] Define repo (plain class or abstract+impl) returning `Future<ApiResponse>`
- [ ] Repo uses `_network.sendRequest()` / `_network.multipartRequest()` — no raw HTTP
- [ ] Create API service extending `GetxService` with `Get.find<Repo>()` in `onInit()`
- [ ] Create state service extending `GetxService` with `instance` getter
- [ ] Create business service extending `GetxService` with response parsing + navigation
- [ ] Create controller extending `GetxController` resolving deps in `onInit()`
- [ ] Create validator with static pure functions returning `String?`
- [ ] Create error handler with `handleAppException(AppException)` and `context.mounted` checks
- [ ] Create DI class with `init()` and `dispose()`, registration order: Repo → State → Services → Controllers

### API Calls
- [ ] All calls go through `ApiCallHandler.call()` (unified: connectivity + loading + 401 refresh)
- [ ] All mutating calls (POST/PUT/PATCH/DELETE) are debounced via `_debouncer.run()`
- [ ] Standard API Service signature: `isLoading`, `errorMessage`, `onSuccess(ApiResponse)`, `onError(AppException)?` — **NO `context`**
- [ ] No hardcoded metadata in API service layer
- [ ] No mock implementations in production code
- [ ] Local storage calls do NOT go through `ApiCallHandler`

### Safety
- [ ] Validate input before every API call (Validator → ErrorHandler → return)
- [ ] Prevent duplicate submissions: `if (isLoading.value) return;`
- [ ] Check `context.mounted` in all `onSuccess` and `onError` callbacks
- [ ] No `print()` statements — use `AppLogger` (uses `developer.log`)
- [ ] No sensitive data in logs
- [ ] File uploads validated (size, format) before sending
- [ ] Separate `RxBool` loading flags per operation type
- [ ] Logout succeeds even if API call fails

### Code Quality
- [ ] Repo uses `NetworkApiServices` exclusively, returns `ApiResponse`
- [ ] Response parsing in Service layer, not Controller
- [ ] Payload preparation in Service layer, not Controller
- [ ] Controller only orchestrates: validate → prevent duplicate → call → handle callbacks
- [ ] All dependencies resolved via `Get.find()` in `onInit()` — no direct instantiation
- [ ] No force-unwrap on nullable `context`
- [ ] Proper `onClose()` with timer/controller disposal
- [ ] Error handler handles `TokenRefreshException` → navigate to login

---

## 11. Quick Reference: Which Layer Does What

| Responsibility | Repo | API Service | Service | State Service | Controller | Validator | Error Handler |
|---|---|---|---|---|---|---|---|
| HTTP calls (`sendRequest`) | YES | — | — | — | — | — | — |
| Debouncing (`_debouncer.run`) | — | YES | — | — | — | — | — |
| `ApiCallHandler.call()` | — | YES | — | — | — | — | — |
| Loading state toggle | — | via ApiCallHandler | — | OWNS | delegates | — | — |
| Business logic | — | — | YES | — | — | — | — |
| Response parsing | — | — | YES | — | — | — | — |
| Payload preparation | — | — | YES | — | — | — | — |
| Navigation | — | — | YES | — | triggers | — | — |
| Reactive state storage | — | — | — | YES | delegates | — | — |
| Orchestration | — | — | — | — | YES | — | — |
| Input validation | — | — | — | — | calls | YES | — |
| Error display (snackbars) | — | — | — | — | — | — | YES |
| Token refresh / 401 | — | via ApiCallHandler | — | — | — | — | handles `TokenRefreshException` |
| `context.mounted` check | — | — | YES | — | YES | — | YES |

---

## 12. Examples from Codebase (Current)

### Auth: Phone Registration Flow
```
AuthController.registerPhone(phone, context)
  1. AuthValidator.validatePhone(phone)                    # Validate
  2. if (isRegistering.value) return;                      # Prevent duplicate
  3. _apiService.registerPhone(                            # API Service (debounced)
       phone, isLoading, errorMessage,
       onSuccess: (ApiResponse response) {                # Typed response
         AuthErrorHandler.handleAuthSuccess(context);
         _stateService.setAuthMode(phone);
         context.push(AppRoutes.otpVerify);
       },
       onError: (AppException error) {                    # Typed error
         AppLogger.e('Auth', 'Registration failed', error);
         AuthErrorHandler.handleAppException(error, context);
       },
     );
  
  Inside AuthApiService.registerPhone():
    _debouncer.run(() async {
      await ApiCallHandler.call(                          # Unified handler
        apiCall: () => _authRepo.registerPhone(phone),    # Repo (plain Dart)
        isLoading, errorMessage, onSuccess, onError,
      );
    });
  
  Inside ApiCallHandler.call():
    1. NetworkManager.checkConnectivity()                  # Connectivity
    2. isLoading.value = true                              # Loading toggle
    3. _authRepo.registerPhone(phone)                      # Network call
       → NetworkApiServices.sendRequest()                  # JSON body
       → Returns ApiResponse<T>                            # Typed response
    4. On 401 → _attemptTokenRefresh() → retry once        # Auto refresh
    5. isLoading.value = false (finally)                    # Loading off
```

### Onboarding: Photo Reorder with Optimistic UI
```
ProfileSetupController.reorderPhotoTiles(oldIndex, newIndex, context)
  1. Save previousOrder (for rollback)
  2. Optimistic local reorder: removeAt(old) → insert(new)
  3. Find moved photo's publicId and new position
  4. _service.handleReorderPhotoByPublicId(
       photoId, toPosition, context,
       onSuccess: (List<ProfilePhoto> photos) {           # Typed response
         draft.update((d) => d.photos = photos);
         _hydratePhotoTilesFromDraft();
       },
       onError: (error) {
         photoTiles.assignAll(previousOrder);              # Rollback
       },
     );
  
  API body (new format):
    { "photoId": "mafs/users/.../photos/xxx", "toPosition": "1" }
  
  (Old format was: { "photoIds": ["id1", "id2", ...] })
```

### Auth: Logout with Resilience
```
AuthController.logout(context)
  1. if (isLoggingOut.value) return;
  2. _apiService.logout(
       isLoading: _stateService.isLoggingOut,
       onSuccess: (response) async {
         await _clearAuthData();
         _stateService.reset();
         _userController.clearUserRecord();
         AppGoRouter.router.go(AppRoutes.welcomeScreen);
       },
       onError: (error) async {
         // Even on failure — still clear locally and navigate out
         await _clearAuthData();
         _stateService.reset();
         AppGoRouter.router.go(AppRoutes.welcomeScreen);
       },
     );
```

### Auth: Splash → Authentication Check
```
AuthController.authentication(context)
  1. Check local refresh token
  2. If no token → navigate to welcome
  3. _apiService.checkAuthStatus() → refreshToken API
  4. Parse user from response data
  5. Save new access token
  6. _userController.saveUserRecord(user)
  7. _stateService.updateAuthState(user)
  8. _authService.handlePostAuthNavigation(user, context)
     → If email verified + onboarding complete → Home
     → If email verified + onboarding incomplete → Profile Setup
     → If email not verified → Auth Entry (email mode)
```

---

## 13. API Body Conventions

### JSON requests (`sendRequest`)
- Body is `Map<String, dynamic>` — `NetworkApiServices` handles `jsonEncode`
- Content-Type is set automatically to `application/json`
- All HTTP methods (POST, PUT, PATCH, DELETE) use the same serialization

```dart
// Simple body
body: {'phone': "+91$phone", 'otp': otp}

// Nested body
body: {
  'profile': { 'nickname': name, 'dob': dobString },
  'discovery': { 'ageRange': { 'min': 18, 'max': 30 } },
}

// Single-item reorder (not array)
body: { 'photoId': publicId, 'toPosition': position.toString() }
```

### Multipart requests (`multipartRequest`)
- Used for file uploads (photos, selfies, documents)
- `fields` parameter is `Map<String, String>` for form fields
- `files` parameter is `List<File>`
- Content-Type is set automatically by multipart

```dart
// Photo upload with metadata
fields: { 'onboarding': jsonEncode(onboardingData) }
files: [photoFile1, photoFile2]
fileFieldName: 'photos'
```

---

**This document is a living reference. When you find a new pattern or anti-pattern, add it here.**
