import 'package:flutter/material.dart';
import '../../../utils/components/snackbar/app_snackbar.dart' show AppSnackBar;
import '../../../utils/constants/enum.dart' show SnackbarType;

class ApiResponseHandler {
  /// Handles common API response patterns (success, error, message display).
  ///
  /// Returns `true` if the status is 'success', `false` otherwise.
  static bool handleResponse({
    required Map<String, dynamic> response,
    required BuildContext context,
    Function(String message)? onSuccess,
    Function(String message)? onError,
  }) {
    if (response.isEmpty) {
      // Handle empty response case, though your original code checks for it.
      // You might want to show a generic error here or let the calling method handle it.
      if (context.mounted) {
        AppSnackBar.showSnackbar(
          type: SnackbarType.error,
          title: 'An unexpected error occurred.',
          context: context,
        );
      }
      return false;
    }

    String status = response['status'] ?? 'error'; // Default to 'error' if status is null
    String message = response['message'] ?? 'Something went wrong.'; // Default message

    if (status == 'success') {
      if (context.mounted) {
        AppSnackBar.showSnackbar(
          type: SnackbarType.success,
          title: message,
          context: context,
        );
      }
      onSuccess?.call(message); // Call the success callback if provided
      return true;
    } else if (status == 'error') {
      print("Error status: $message");
      if (context.mounted) {
        AppSnackBar.showSnackbar(
          type: SnackbarType.warning,
          title: message,
          context: context,
        );
      }
      onError?.call(message); // Call the error callback if provided
      return false;
    } else {
      if (context.mounted) {
        AppSnackBar.showSnackbar(
          type: SnackbarType.error,
          title: 'Unknown response status: $status',
          context: context,
        );
      }
      return false;
    }
  }
}
