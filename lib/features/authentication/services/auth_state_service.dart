import 'package:get/get.dart';

class AuthStateService extends GetxService {
  static AuthStateService get instance => Get.find();

  // Loading states
  final RxBool isAuthenticating = false.obs;
  final RxBool isVerifying = false.obs;

  // Error handling
  final RxString errorMessage = ''.obs;

  void clearError() {
    errorMessage.value = '';
  }
}
