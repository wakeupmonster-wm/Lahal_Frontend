import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../components/snackbar/app_snackbar.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  BuildContext context;
  NetworkManager(this.context);

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final Rx<List<ConnectivityResult>> _connectionStatus =
      Rx<List<ConnectivityResult>>([ConnectivityResult.none]);

  bool _isFirstCheck =
      true; // Flag to prevent multiple initial offline notifications

  // Initialize the network manager and set up a stream to continually check the connection status.
  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  // Check the initial connectivity status when the app starts
  Future<void> _checkInitialConnection() async {
    bool connected = await isConnected();
    if (!connected && _isFirstCheck) {
      AppSnackBar.showToast(message: "You are currently offline.");
      _isFirstCheck =
          false; // Ensure we only show the offline toast once at startup
    }
  }

  // Update the connection status based on changes in connectivity and show a relevant popup for no internet connection.
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    _connectionStatus.value = results;

    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      // AppSnackBar.showToast(message: "You are currently offline.");
    }
  }

  // Check the internet connection status
  // Return 'true' if connected, 'false' otherwise
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.none) || result.isEmpty) {
        AppSnackBar.showToast(message: "You are currently offline.");
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  // Dispose or close the native connectivity status
  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription.cancel();
  }
}
