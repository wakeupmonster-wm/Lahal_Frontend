import 'dart:io';

class AddRestaurantModel {
  final String name;
  final String address;
  final String city;
  final String halalStatus;
  final List<File> images;
  final String? additionalNote;

  AddRestaurantModel({
    required this.name,
    required this.address,
    required this.city,
    required this.halalStatus,
    required this.images,
    this.additionalNote,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'city': city,
      'halal_status': halalStatus,
      'additional_note': additionalNote,
      // Images will be handled separately by the repository (multipart)
    };
  }
}
