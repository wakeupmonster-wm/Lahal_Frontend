import 'dart:async';
import 'package:get/get.dart';
import 'package:lahal_application/features/prey/model/prayer_time_model.dart';
import 'package:lahal_application/features/prey/repo/prayer_repository.dart';

class PrayerController extends GetxController {
  final PrayerRepository _repository = PrayerRepository();

  final RxList<PrayerTimeModel> prayerTimes = <PrayerTimeModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentTime = "".obs;
  final RxString timeRemaining = "00:06:59".obs; // Mock countdown
  final RxString currentLocation = "Melbourne, Victoria (VIC)".obs;
  final Rx<PrayerTimeModel?> upcomingPrayer = Rx<PrayerTimeModel?>(null);

  Timer? _clockTimer;

  @override
  void onInit() {
    super.onInit();
    _startClock();
    fetchPrayerTimes();
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }

  void _startClock() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      currentTime.value =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
      // In a real app, logic to update 'timeRemaining' would go here
    });
  }

  Future<void> fetchPrayerTimes() async {
    try {
      isLoading.value = true;
      final results = await _repository.fetchPrayerTimes();
      prayerTimes.assignAll(results);
      upcomingPrayer.value = prayerTimes.firstWhereOrNull((p) => p.isUpcoming);
    } catch (e) {
      print("Error fetching prayer times: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
