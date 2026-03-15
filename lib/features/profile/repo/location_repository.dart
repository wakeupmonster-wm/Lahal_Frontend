import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as https;

import '../model/location_model.dart';

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/location_model.dart';

class LocationRepository {
  Future<List<LocationModel>> searchLocations(String query) async {
    if (query.isEmpty) return [];

    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];

    final uri = Uri.https(
      "maps.googleapis.com",
      "/maps/api/place/autocomplete/json",
      {"input": query, "key": apiKey!, "types": "geocode"},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final predictions = data["predictions"];

      return predictions.map<LocationModel>((place) {
        return LocationModel(
          title: place["structured_formatting"]["main_text"],
          subtitle: place["description"],
        );
      }).toList();
    } else {
      throw Exception("Failed to fetch locations");
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
