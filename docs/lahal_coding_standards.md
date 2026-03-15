# Lahal Application Coding Standards & API Integration Rules

> **Status**: Living document — standardizing Lahal_Frontend to match our gold-standard MAFS Architecture.

---

## 1. Directory Structure

We enforce a strict feature-first folder structure. Every feature must contain the following layers nicely separated:

```
lib/features/[feature_name]/
├── controller/
│   └── [feature]_controller.dart        # Business logic & UI state management (GetxController)
├── services/
│   ├── [feature]_api_service.dart       # API calls + debouncing (GetxService)
│   ├── [feature]_service.dart           # Business logic + navigation (GetxService)
│   └── [feature]_state_service.dart     # Reactive state (GetxService)
├── utils/
│   ├── [feature]_error_handler.dart     # Centralized error UI (static methods)
│   └── [feature]_validator.dart         # Pure validation functions (static methods)
├── repo/
│   └── [feature]_repo.dart              # Concrete implementation (plain Dart class hitting NetworkApiServices)
└── view/
    ├── screens/
    └── widgets/
```

---

## 2. API Architecture Pattern

The data flows **DOWN** and callbacks/responses flow **UP**.

1. **UI (Widget/Screen)** calls an action on the **Controller**.
2. **Controller** validates data and triggers the **Service layer**.
3. **API Service** wraps the call in `AppDebouncer` and delegates to `ApiCallHandler`.
4. **ApiCallHandler** checks connectivity, toggles the `isLoading` state, handles 401 token refresh loops, and catches strongly-typed `AppExceptions`!
5. **Repository** maps directly to the endpoint URL and passes the raw `Map<String, dynamic>` to `NetworkApiServices`.
6. **NetworkApiServices** encodes the JSON, tracks performance, and returns a strongly-typed `ApiResponse<T>`.

---

## 3. Strict Development Rules

- **No `print()` or `.log()`:** Use `AppLogger.d()`, `AppLogger.i()`, `AppLogger.e()`, `AppLogger.w()`. Built on top of `dart:developer`, it logs completely and intelligently skips in production.
- **Context Handling:** You **MUST** check `if (!context.mounted) return;` after any `await` before trying to show a SnackBar or navigate. Do not force unwrap `context!`.
- **API Debouncing:** Any mutating method (POST/PUT/PATCH/DELETE) must be wrapped inside `_debouncer.run(() async { ... })` inside the API Service to prevent spam clicks.
- **No Manual Request Building:** Repositories only call `_network.sendRequest()` and pass a `Map<String, dynamic>`. They do not manually JSON encode payload bodies, strings, or attach authorization headers.
- **Exceptions:** Always throw typed exceptions defined in `app_exception.dart` (e.g. `ValidationException`, `NotFoundException`).
- **Dependency Injection:** Access Repositories and Services via `Get.find<Type>()` inside `onInit()`. Do not create local object instances manually using `final repo = AuthRepo();`.

---

## 4. API Call Example (Authentication)

### Step 1: Repository (Plain Dart Class)
```dart
class AuthenticationRepository {
  final NetworkApiServices _network = NetworkApiServices();

  Future<ApiResponse> signIn(Map<String, dynamic> body) async {
    return await _network.sendRequest(
      url: AppUrls.signIn,
      method: HttpMethod.post,
      body: body, // NetworkApiServices does the jsonEncode automatically!
      includeHeaders: false,
    );
  }
}
```

### Step 2: API Service (GetxService with Debouncer and ApiCallHandler)
```dart
class AuthApiService extends GetxService {
  late final AuthenticationRepository _authRepo;
  final AppDebouncer _debouncer = AppDebouncer(milliseconds: 100);

  @override
  void onInit() {
    super.onInit();
    _authRepo = Get.find<AuthenticationRepository>();
  }

  // Mutating API calls MUST be debounced!
  void signIn({
    required Map<String, dynamic> payload,
    required RxBool isLoading,
    required RxString errorMessage,
    required Function(ApiResponse response) onSuccess,
    Function(AppException error)? onError,
  }) {
    _debouncer.run(() async {
      await ApiCallHandler.call(
        apiCall: () => _authRepo.signIn(payload),
        isLoading: isLoading,
        errorMessage: errorMessage,
        onSuccess: onSuccess,
        onError: onError,
      );
    });
  }
}
```

### Step 3: Controller (Invokes Service)
```dart
class SignInController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  void onSignIn(BuildContext context) {
      if (!formKey.currentState!.validate()) return;
      
      final authApiService = Get.find<AuthApiService>();
      
      authApiService.signIn(
         payload: {
           'country_code': countryCodeController.text,
           'phone_number': phoneNumberController.text,
         },
         isLoading: isLoading,
         errorMessage: errorMessage,
         onSuccess: (response) {
            // Handle Success response data mapping here
            if (context.mounted) {
               context.push(AppRoutes.otpVerify);
            }
         },
         onError: (error) {
            // Error mapped securely by ApiCallHandler. No print() used!
            AppLogger.e('SignInController', 'Sign in failed', error);
         }
      );
  }
}
```
