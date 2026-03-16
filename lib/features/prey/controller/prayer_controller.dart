import 'dart:async';
import 'package:get/get.dart';
import 'package:lahal_application/features/home/controller/location_controller.dart';
import 'package:lahal_application/features/prey/model/prayer_time_model.dart';
import 'package:lahal_application/features/prey/repo/prayer_repository.dart';

class PrayerController extends GetxController {
  final PrayerRepository _repository = PrayerRepository();

  late final LocationController locationController;

  final RxList<PrayerTimeModel> prayerTimes = <PrayerTimeModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString currentTime = "".obs;
  final RxString timeRemaining = "00:00:00".obs;
  final Rx<PrayerTimeModel?> upcomingPrayer = Rx<PrayerTimeModel?>(null);

  RxString get currentLocation => locationController.currentAddress;


  Timer? _clockTimer;

  @override
  void onInit() {
    super.onInit();
    // Ensure LocationController is accessible
    locationController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController());

    _startClock();

    // Listen to location changes so we refresh when they finally allow it
    ever(locationController.hasLocation, (bool hasLocation) {
      if (hasLocation) {
        fetchPrayerTimes();
      }
    });

    if (locationController.hasLocation.value) {
      fetchPrayerTimes();
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    super.onClose();
  }

  void _startClock() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      // Current HH:mm
      currentTime.value =
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

      _updateCountdown(now);
    });
  }

  void _updateCountdown(DateTime now) {
    if (prayerTimes.isEmpty) return;

    // Find the next prayer
    // time string is "HH:mm"
    DateTime? nextPrayerTime;
    PrayerTimeModel? nextPrayer;

    for (var p in prayerTimes) {
      final parts = p.time.split(':');
      if (parts.length != 2) continue;
      
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final pTime = DateTime(now.year, now.month, now.day, hour, minute);

      // We want the first prayer that is strictly after 'now'
      if (pTime.isAfter(now)) {
        nextPrayer = p;
        nextPrayerTime = pTime;
        break;
      }
    }

    // If none found today, the next is Fajr tomorrow
    if (nextPrayer == null && prayerTimes.isNotEmpty) {
      // Fajr is usually index 0
      final p = prayerTimes.first;
      final parts = p.time.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      
      nextPrayer = p;
      // Add 1 day
      nextPrayerTime = DateTime(now.year, now.month, now.day + 1, hour, minute);
    }

    if (nextPrayer != null && nextPrayerTime != null) {
      if (upcomingPrayer.value != nextPrayer) {
        upcomingPrayer.value = nextPrayer;
        
        // Update isUpcoming flag in the list explicitly
        final newList = prayerTimes.map((item) {
          return PrayerTimeModel(
            name: item.name,
            time: item.time,
            isUpcoming: item.name == nextPrayer?.name,
          );
        }).toList();
        prayerTimes.assignAll(newList);
      }

      final diff = nextPrayerTime.difference(now);
      final h = diff.inHours;
      final m = diff.inMinutes.remainder(60);
      final s = diff.inSeconds.remainder(60);

      timeRemaining.value =
          "-${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
    }
  }

  Future<void> fetchPrayerTimes() async {
    final lat = locationController.latitude.value;
    final lng = locationController.longitude.value;

    if (lat == 0.0 && lng == 0.0) return;

    try {
      isLoading.value = true;
      final now = DateTime.now();
      final dateStr =
          "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

      final results = await _repository.fetchPrayerTimes(
        lat: lat,
        lng: lng,
        dateStr: dateStr,
      );

      prayerTimes.assignAll(results);
      _updateCountdown(DateTime.now());
    } catch (e) {
      print("Error fetching prayer times: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
