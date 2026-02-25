import 'package:lahal_application/features/prey/model/prayer_time_model.dart';

class PrayerRepository {
  Future<List<PrayerTimeModel>> fetchPrayerTimes() async {
    // Mocking data for now as per image: Fajr, Sunrise, Dhuhr, Asr, Magrib, Isha
    // In a real app, this would call an API or use a plugin like 'adhan'
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network lag

    return [
      PrayerTimeModel(name: "Fajr", time: "05:19"),
      PrayerTimeModel(name: "Sunrise", time: "05:19"),
      PrayerTimeModel(name: "Dhuhr", time: "05:19"),
      PrayerTimeModel(name: "Asr", time: "05:19"),
      PrayerTimeModel(name: "Magrib", time: "05:19", isUpcoming: true),
      PrayerTimeModel(name: "Isha", time: "05:19"),
    ];
  }
}
