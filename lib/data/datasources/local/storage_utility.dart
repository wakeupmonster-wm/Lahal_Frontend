import 'package:get_storage/get_storage.dart';

class AppLocalStorage {
  late final GetStorage _storage;

  // Singleton instance
  static AppLocalStorage? _instance;

  AppLocalStorage._internal();

  factory AppLocalStorage.instance() {
    _instance ??= AppLocalStorage._internal();
    return _instance!;
  }

  static Future<void> init(String bucketName) async {
    await GetStorage.init(bucketName);
    _instance = AppLocalStorage.instance();
    _instance!._storage = GetStorage(bucketName);
  }

  // Reset AppLocalStorage initialization
  static Future<void> reset() async {
    await AppLocalStorage.instance().clearAll();
    _instance = null;
  }

  //final _storage = GetStorage();

  // Generic method to save data
  Future<void> writeData<T>(String key, T value) async {
    await _storage.write(key, value);
  }

  // Generic method to save data if null
  Future<void> writeDataIfNull<T>(String key, T value) async {
    if (_storage.read(key) == null) {
      await _storage.write(key, value);
    }
  }

  // Generic method to read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Generic method to remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data in storage
  Future<void> clearAll() async {
    await _storage.erase();
  }
}
