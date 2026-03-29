class LocationModel {
  final String title;
  final String subtitle;
  final String? placeId;

  const LocationModel({
    required this.title,
    required this.subtitle,
    this.placeId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      placeId: json['placeId'],
    );
  }
}
