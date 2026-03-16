class SavedLocationData {
  final String type;
  final List<double> coordinates;
  final String address;
  final String city;
  final String state;

  const SavedLocationData({
    required this.type,
    required this.coordinates,
    required this.address,
    required this.city,
    required this.state,
  });

  factory SavedLocationData.fromJson(Map<String, dynamic> json) {
    return SavedLocationData(
      type: json['type'] as String? ?? '',
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
    );
  }

  /// Longitude is the first coordinate in a GeoJSON Point.
  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0.0;

  /// Latitude is the second coordinate in a GeoJSON Point.
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0.0;

  @override
  String toString() =>
      'SavedLocationData(type: $type, city: $city, state: $state, address: $address, coordinates: $coordinates)';
}
