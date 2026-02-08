import 'package:get/get.dart';
import 'package:lahal_application/features/profile/repo/profile_repository.dart';

class NotificationPreferenceController extends GetxController {
  final ProfileRepository _profileRepo = ProfileRepository();

  final RxBool offersEnabled = false.obs;
  final RxBool prayerAlertsEnabled = false.obs;
  final RxBool reviewUpdatesEnabled = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPreferences();
  }

  void fetchPreferences() async {
    isLoading.value = true;
    try {
      // Simulate API call
      // final response = await _profileRepo.getNotificationPreferences();
      // ... update values from response ...

      // Dummy data for now
      offersEnabled.value = true;
      prayerAlertsEnabled.value = false;
      reviewUpdatesEnabled.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleOffers(bool value) =>
      _updatePreference('offers', value, offersEnabled);
  void togglePrayerAlerts(bool value) =>
      _updatePreference('prayer', value, prayerAlertsEnabled);
  void toggleReviewUpdates(bool value) =>
      _updatePreference('review', value, reviewUpdatesEnabled);

  void _updatePreference(String key, bool value, RxBool target) async {
    final originalValue = target.value;
    target.value = value;

    try {
      // await _profileRepo.updateNotificationPreferences({key: value.toString()});
    } catch (e) {
      target.value = originalValue;
      // Show snackbar error
    }
  }
}
