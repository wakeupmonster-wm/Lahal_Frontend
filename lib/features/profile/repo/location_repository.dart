import '../model/location_model.dart';

class LocationRepository {
  Future<List<LocationModel>> searchLocations(String query) async {
    // Mocking an API call with a delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Static mock data
    final allLocations = [
      const LocationModel(
        title: "Narre Warren South",
        subtitle: "VIC, Australia",
      ),
      const LocationModel(title: "Narre Warren", subtitle: "VIC, Australia"),
      const LocationModel(
        title: "Narre Warren North",
        subtitle: "VIC, Australia",
      ),
      const LocationModel(title: "Warrenheip", subtitle: "VIC, Australia"),
      const LocationModel(title: "Warrendyte", subtitle: "VIC, Australia"),
    ];

    if (query.isEmpty) return allLocations;

    return allLocations
        .where(
          (loc) =>
              loc.title.toLowerCase().contains(query.toLowerCase()) ||
              loc.subtitle.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
