class AddRestaurantRequest {
  final String restaurantName;
  final RestaurantAddress address;
  final String halalStatus;
  final List<FoodImage> foodsImages;

  AddRestaurantRequest({
    required this.restaurantName,
    required this.address,
    required this.halalStatus,
    required this.foodsImages,
  });

  Map<String, dynamic> toJson() {
    return {
      'restaurantName': restaurantName,
      'address': address.toJson(),
      'halalStatus': halalStatus,
      'foodsImages': foodsImages.map((i) => i.toJson()).toList(),
    };
  }
}

class RestaurantAddress {
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String pincode;

  RestaurantAddress({
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullAddress': fullAddress,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
    };
  }
}

class FoodImage {
  final String url;
  final String publicId;
  final String uploadedAt;

  FoodImage({
    required this.url,
    required this.publicId,
    required this.uploadedAt,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) {
    return FoodImage(
      url: json['url'] ?? '',
      publicId: json['publicId'] ?? '',
      uploadedAt: json['uploadedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'publicId': publicId, 'uploadedAt': uploadedAt};
  }
}
