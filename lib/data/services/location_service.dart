import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationPermissionDeniedException implements Exception {
  final String message;
  LocationPermissionDeniedException(this.message);
  @override
  String toString() => message;
}

class LocationService {
  static Future<Position> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationPermissionDeniedException(
        "Location services are disabled.",
      );
    }

    var status = await ph.Permission.location.status;
    if (status.isDenied) {
      status = await ph.Permission.location.request();
      if (!status.isGranted) {
        throw LocationPermissionDeniedException("Location permission denied.");
      }
    }

    if (status.isPermanentlyDenied) {
      throw LocationPermissionDeniedException(
        "Location permission permanently denied.",
      );
    }

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
        Placemark place = placemarks[0];
        String city = place.locality ?? place.subAdministrativeArea ?? "";
        String state = place.administrativeArea ?? "";
        String country = place.isoCountryCode ?? "";

        if (city.isNotEmpty && state.isNotEmpty) {
          return "$city, $state ($country)";
        } else if (city.isNotEmpty) {
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
