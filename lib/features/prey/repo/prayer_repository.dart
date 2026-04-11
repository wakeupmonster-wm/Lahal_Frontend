import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lahal_application/features/prey/model/prayer_time_model.dart';
import 'package:lahal_application/utils/constants/app_urls.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class PrayerRepository {
  /// Fetches prayer times from Aladhan API using Coordinates.
  /// Bypasses NetworkApiServices because Aladhan does not return "success: true" structure.
  Future<List<PrayerTimeModel>> fetchPrayerTimes({
    required double lat,
    required double lng,
    required String dateStr,
  }) async {
    try {
      final uri = Uri.parse('${AppUrls.aladhanBaseUrl}/timings/$dateStr')
          .replace(
            queryParameters: {
              'latitude': lat.toString(),
              'longitude': lng.toString(),
              'method': '2', // ISNA method
            },
          );

      AppLogger.i('PrayerRepository', 'Fetching prayer times: $uri');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'];
        final timings = data['timings'] as Map<String, dynamic>;

        // The specific prayers we want to display, in order
        final requiredPrayers = [
          'Fajr',
          'Sunrise',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];

        final List<PrayerTimeModel> result = [];
        for (var name in requiredPrayers) {
          if (timings.containsKey(name)) {
            result.add(
              PrayerTimeModel(
                name: name,
                time: timings[name],
                // isUpcoming will be calculated securely in Controller
              ),
            );
          }
        }
        return result;
      } else {
        AppLogger.e('PrayerRepository', 'Failed to fetch: ${response.body}');
        return [];
      }
    } catch (e, stack) {
      AppLogger.e('PrayerRepository', 'Error fetching prayer times', e, stack);
      return [];
    }
  }
}
