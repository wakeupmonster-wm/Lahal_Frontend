class RestaurantModel {
  // ---- Core fields (from list API) ----
  final String id;
  final String restaurantName;
  final String cuisine;
  final RestaurantAddress address;
  final RestaurantLocation location;
  final String phone;
  final bool isOpenNow;
  final bool isFavourite;
  final double? distanceInKm;
  final RestaurantMetrics metrics;
  final HalalInfo halalInfo;
  final String restaurantImg;

  // ---- Extended fields (used by details screen, optional for list) ----
  final String? description;
  final String? openingHours;
  final List<String> halalSummary;
  final List<String> photos;
  final Map<String, bool> amenities;
  final List<ReviewModel> reviews;
  final SocialConnects? socialConnects;

  const RestaurantModel({
    required this.id,
    required this.restaurantName,
    required this.cuisine,
    required this.address,
    required this.location,
    required this.phone,
    required this.isOpenNow,
    required this.isFavourite,
    required this.distanceInKm,
    required this.metrics,
    required this.halalInfo,
    required this.restaurantImg,
    // Extended (optional for list API)
    this.description,
    this.openingHours,
    this.halalSummary = const [],
    this.photos = const [],
    this.amenities = const {},
    this.reviews = const [],
    this.socialConnects,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id']?.toString() ?? '',
      restaurantName: json['restaurantName']?.toString() ?? '',
      cuisine: json['cuisine']?.toString() ?? '',
      address: RestaurantAddress.fromJson(
        json['address'] as Map<String, dynamic>? ?? {},
      ),
      location: RestaurantLocation.fromJson(
        json['location'] as Map<String, dynamic>? ?? {},
      ),
      phone: json['phone']?.toString() ?? '',
      isOpenNow: json['isOpenNow'] == true,
      isFavourite: json['isFavourite'] == true,
      distanceInKm: _parseDistance(json['distanceInKm']),
      metrics: RestaurantMetrics.fromJson(
        json['metrics'] as Map<String, dynamic>? ?? {},
      ),
      halalInfo: HalalInfo.fromJson(
        json['halalInfo'] as Map<String, dynamic>? ?? {},
      ),
      restaurantImg: json['restaurantImg']?.toString() ?? '',
    );
  }

  RestaurantModel copyWith({
    String? id,
    String? restaurantName,
    String? cuisine,
    RestaurantAddress? address,
    RestaurantLocation? location,
    String? phone,
    bool? isOpenNow,
    bool? isFavourite,
    double? distanceInKm,
    RestaurantMetrics? metrics,
    HalalInfo? halalInfo,
    String? restaurantImg,
    String? description,
    String? openingHours,
    List<String>? halalSummary,
    List<String>? photos,
    Map<String, bool>? amenities,
    List<ReviewModel>? reviews,
    SocialConnects? socialConnects,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      restaurantName: restaurantName ?? this.restaurantName,
      cuisine: cuisine ?? this.cuisine,
      address: address ?? this.address,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      isOpenNow: isOpenNow ?? this.isOpenNow,
      isFavourite: isFavourite ?? this.isFavourite,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      metrics: metrics ?? this.metrics,
      halalInfo: halalInfo ?? this.halalInfo,
      restaurantImg: restaurantImg ?? this.restaurantImg,
      description: description ?? this.description,
      openingHours: openingHours ?? this.openingHours,
      halalSummary: halalSummary ?? this.halalSummary,
      photos: photos ?? this.photos,
      amenities: amenities ?? this.amenities,
      reviews: reviews ?? this.reviews,
      socialConnects: socialConnects ?? this.socialConnects,
    );
  }

  /// Parse distanceInKm — API may return a number (2.5) or a string ("1.27km away")
  static double? _parseDistance(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      // Extract the numeric part from strings like "1.27km away"
      final match = RegExp(r'[\d.]+').firstMatch(value);
      if (match != null) return double.tryParse(match.group(0)!);
    }
    return null;
  }

  /// Formatted distance string for display
  String get formattedDistance {
    if (distanceInKm == null) return '';
    if (distanceInKm! < 1) {
      return '${(distanceInKm! * 1000).round()} m';
    }
    return '${distanceInKm!.toStringAsFixed(1)} km';
  }

  /// Status text derived from isOpenNow
  String get statusText => isOpenNow ? 'Open now' : 'Closed';

  @override
  String toString() =>
      'RestaurantModel(id: $id, restaurantName: $restaurantName)';
}

// ---- Sub-models ----

class RestaurantAddress {
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String pincode;

  const RestaurantAddress({
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) {
    return RestaurantAddress(
      fullAddress: json['fullAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
    );
  }
}

class RestaurantLocation {
  final String type;
  final double longitude;
  final double latitude;

  const RestaurantLocation({
    required this.type,
    required this.longitude,
    required this.latitude,
  });

  factory RestaurantLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List<dynamic>? ?? [];
    return RestaurantLocation(
      type: json['type']?.toString() ?? 'Point',
      longitude: coords.isNotEmpty ? (coords[0] as num).toDouble() : 0.0,
      latitude: coords.length > 1 ? (coords[1] as num).toDouble() : 0.0,
    );
  }
}

class RestaurantMetrics {
  final double avgRating;
  final int totalReviews;

  const RestaurantMetrics({
    required this.avgRating,
    required this.totalReviews,
  });

  factory RestaurantMetrics.fromJson(Map<String, dynamic> json) {
    return RestaurantMetrics(
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
    );
  }
}

class HalalInfo {
  final bool isCertified;
  final String summary;

  const HalalInfo({
    required this.isCertified,
    required this.summary,
  });

  factory HalalInfo.fromJson(Map<String, dynamic> json) {
    return HalalInfo(
      isCertified: json['isCertified'] == true,
      summary: json['summary']?.toString() ?? '',
    );
  }
}

// ---- Kept for restaurant details screen ----

class ReviewModel {
  final String userName;
  final String userImageUrl;
  final String date;
  final double rating;
  final String comment;

  const ReviewModel({
    required this.userName,
    required this.userImageUrl,
    required this.date,
    required this.rating,
    required this.comment,
  });
}

class SocialConnects {
  final String? website;
  final String? facebook;
  final String? email;
  final String twitter;

  const SocialConnects({
    this.website,
    this.facebook,
    this.email,
    required this.twitter,
  });
}
