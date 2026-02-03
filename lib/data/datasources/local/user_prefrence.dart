import 'storage_utility.dart';

class UserPreferences {
  final AppLocalStorage _storage = AppLocalStorage.instance();

  // -- Set token (auth token)
  Future<void> setToken(String authToken) async {
    await _storage.writeData('x-auth-token', authToken);
    print("Token Saved --> $authToken");
  }

  // -- Get token (auth token)
  Future<String?> getToken() async {
    return _storage.readData<String>('x-auth-token');
  }

  // -- Remove token (auth token)
  Future<void> removeToken() async {
    await _storage.removeData('x-auth-token');
  }

  // -- Print token (auth token)
  Future<void> printToken() async {
    final token = await getToken();
    if (token != null) {
      print("Token: $token");
    }
  }

  // -- Set user-id
  Future<void> setUserId(String id) async {
    await _storage.writeData("user_id", id);
  }

  // -- Get user-id
  Future<String> getUserId() async {
    return _storage.readData<String>("user_id") ?? "";
  }

  // -- Set device token
  Future<void> setDeviceToken(String deviceToken) async {
    await _storage.writeData('device_token', deviceToken);
    print("Device Token Saved --> $deviceToken");
  }

  // -- Get device token
  Future<String?> getDeviceToken() async {
    return _storage.readData<String>('device_token');
  }

  // -- Remove device token
  Future<void> removeDeviceToken() async {
    await _storage.removeData('device_token');
  }

  // -- Print device token
  Future<void> printDeviceToken() async {
    final deviceToken = await getDeviceToken();
    if (deviceToken != null) {
      print("Device Token: $deviceToken");
    }
  }

  // -- Get header
  Future<Map<String, String>> getHeader() async {
    final String? token = await getToken();
    if (token == null) return <String, String>{};
    return {
      'Authorization': 'Bearer $token',
      // 'Accept': 'application/json',
    };
  }

  // -- Clear all data
  Future<void> clearAll() async {
    await _storage.clearAll();
  }
}
 
 // -- Not in Use for this app but can be used in future
  // // -- Set isFirstTime
  // Future<void> setIsFirstTime(bool isFirstTime) async {
  //   await _storage.writeData('isFirstTime', isFirstTime);
  // }

  // // -- isFirstTime if Null
  // Future<void> setIsFirstTimeIfNull() async {
  //   await _storage.writeDataIfNull('isFirstTime', true);
  // }

  // // -- Get isFirstTime
  // Future<bool> getIsFirstTime() async {
  //   return _storage.readData<bool>('isFirstTime') ?? true;
  // }

   // -- Clear all data
  // Future<void> clearAll() async {
  //   final bool isFirstTime = await getIsFirstTime();
  //   await _storage.clearAll();
  //   setIsFirstTime(isFirstTime);
  // }
