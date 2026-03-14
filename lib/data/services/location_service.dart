import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationService {
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<String> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String city = place.locality ?? place.subAdministrativeArea ?? "";
        String state = place.administrativeArea ?? "";
        String country = place.isoCountryCode ?? "";

        if (city.isNotEmpty && state.isNotEmpty) {
          return "$city, $state ($country)";
        }

        if (city.isNotEmpty) {
          return "$city ($country)";
        }
      }

      return "Unknown Location";
    } catch (e) {
      return "Unknown Location";
    }
  }

  static Future<void> openAppSettings() async {
    await ph.openAppSettings();
  }
}
