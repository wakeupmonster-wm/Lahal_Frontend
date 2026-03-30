import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lahal_application/data/models/api_response.dart';
import '../model/location_model.dart';

class SearchLocationRepository {
  Future<ApiResponse<List<LocationModel>>> searchLocations(String query) async {
    if (query.isEmpty) {
      return const ApiResponse(status: true, message: 'Empty query', data: []);
    }

    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      final uri = Uri.https(
        "maps.googleapis.com",
        "/maps/api/place/autocomplete/json",
        {"input": query, "key": apiKey!, "types": "geocode"},
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictions = data["predictions"] as List;

        final results = predictions.map<LocationModel>((place) {
          return LocationModel(
            title: place["structured_formatting"]["main_text"],
            subtitle: place["description"],
            placeId: place["place_id"],
          );
        }).toList();

        return ApiResponse(status: true, message: 'Success', data: results);
      } else {
        return const ApiResponse(
          status: false,
          message: 'Failed to fetch suggestions',
        );
      }
    } catch (e) {
      return ApiResponse(status: false, message: e.toString());
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getPlaceDetails(
    String placeId,
  ) async {
    try {
      final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
      final uri =
          Uri.https("maps.googleapis.com", "/maps/api/place/details/json", {
            "place_id": placeId,
            "key": apiKey!,
            "fields": "geometry,address_components,formatted_address",
          });

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data["result"];

        final lat = result["geometry"]["location"]["lat"];
        final lng = result["geometry"]["location"]["lng"];
        final address = result["formatted_address"];

        String city = "";
        String state = "";

        final components = result["address_components"] as List;
        for (var comp in components) {
          final types = comp["types"] as List;
          if (types.contains("locality")) {
            city = comp["long_name"];
          } else if (types.contains("administrative_area_level_1")) {
            state = comp["long_name"];
          }
        }

        final details = {
          "lat": lat.toDouble(),
          "lng": lng.toDouble(),
          "address": address,
          "city": city,
          "state": state,
        };

        return ApiResponse(status: true, message: 'Success', data: details);
      } else {
        return const ApiResponse(
          status: false,
          message: 'Failed to fetch coordinates',
        );
      }
    } catch (e) {
      return ApiResponse(status: false, message: e.toString());
    }
  }
}

// Future<List<LocationModel>> searchLocations(String query) async {
//   // Mocking an API call with a delay
//   await Future.delayed(const Duration(milliseconds: 500));

//   // Static mock data
//   final allLocations = [
//     const LocationModel(
//       title: "Narre Warren South",
//       subtitle: "VIC, Australia",
//     ),
//     const LocationModel(title: "Narre Warren", subtitle: "VIC, Australia"),
//     const LocationModel(
//       title: "Narre Warren North",
//       subtitle: "VIC, Australia",
//     ),
//     const LocationModel(title: "Warrenheip", subtitle: "VIC, Australia"),
//     const LocationModel(title: "Warrendyte", subtitle: "VIC, Australia"),
//   ];

//   if (query.isEmpty) return allLocations;

//   return allLocations
//       .where(
//         (loc) =>
//             loc.title.toLowerCase().contains(query.toLowerCase()) ||
//             loc.subtitle.toLowerCase().contains(query.toLowerCase()),
//       )
//       .toList();
// }
