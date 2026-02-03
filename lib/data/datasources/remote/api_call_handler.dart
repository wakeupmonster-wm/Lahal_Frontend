import 'package:lahal_application/utils/components/snackbar/app_snackbar.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ApiCallHandler {
  static final ApiCallHandler _instance = ApiCallHandler._internal();
  ApiCallHandler._internal();

  factory ApiCallHandler() {
    return _instance;
  }

  void log(String message) {
    message.log("ApiCallHandler");
  }

  void onErrorHandler(Object? error, StackTrace stackTrace) {
    log("$error $stackTrace");
  }

  void handleApiError(
    BuildContext context,
    Object error,
    StackTrace stackTrace,
    RxString errorMessage,
  ) {
    // Update the error message
    errorMessage.value = error.toString();

    if (context.mounted) {
      AppSnackBar.showSnackbar(
        context: context,
        title: "Oh Snap!",
        type: SnackbarType.error,
        message: errorMessage.value,
      );
    }
    onErrorHandler(error, stackTrace);
  }

  Future<bool> _isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> apiHandler<T>({
    required BuildContext context,
    required Future<T> Function() apiCall,
    required RxBool isLoading,
    void Function(T result)? onSuccess,
    required RxString errorMessage,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      isLoading.value = true;
      final result = await apiCall();
      if (onSuccess != null) onSuccess(result);
    } catch (error, stackTrace) {
      if (onError != null) {
        onError(error, stackTrace);
      } else if (context.mounted) {
        handleApiError(context, error, stackTrace, errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> apiHandlerWithConnectivity<T>({
    required BuildContext context,
    required Future<T> Function() apiCall,
    required RxBool isLoading,
    required void Function(T result) onSuccess,
    required RxString errorMessage,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    if (!await _isConnected()) {
      AppSnackBar.showSnackbar(
        context: context,
        title: "No Internet",
        type: SnackbarType.error,
        message: "Please check your internet connection.",
      );
      return;
    }

    await apiHandler(
      context: context,
      apiCall: apiCall,
      isLoading: isLoading,
      onSuccess: onSuccess,
      errorMessage: errorMessage,
      onError: onError,
    );
  }
}
