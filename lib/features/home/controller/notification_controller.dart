import 'package:get/get.dart';
import 'package:lahal_application/features/home/model/notification_model.dart';
import 'package:lahal_application/features/home/repo/notification_repository.dart';

class NotificationController extends GetxController {
  final NotificationRepository _repository = NotificationRepository();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    try {
      isLoading.value = true;
      final result = await _repository.fetchNotifications();
      notifications.assignAll(result);
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
