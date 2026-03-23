class RestaurantDetailsModel {
  final String id;
  final String restaurantName;
  final String about;
  final String cuisine;
  final RestaurantDetailsAddress address;
  final RestaurantDetailsLocation location;
  final RestaurantDetailsAmenities amenities;
  final RestaurantDetailsContact contact;
  final RestaurantDetailsHalalInfo halalInfo;
  final RestaurantDetailsPolicy policy;
  final RestaurantDetailsStatus status;
  final RestaurantDetailsMetrics metrics;
  final RestaurantDetailsMedia media;
  final List<RestaurantDetailsReview> reviews;
  final String createdAt;
  final String updatedAt;

  RestaurantDetailsModel({
    required this.id,
    required this.restaurantName,
    required this.about,
    required this.cuisine,
    required this.address,
    required this.location,
    required this.amenities,
    required this.contact,
    required this.halalInfo,
    required this.policy,
    required this.status,
    required this.metrics,
    required this.media,
    required this.reviews,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsModel(
      id: json['_id']?.toString() ?? '',
      restaurantName: json['restaurantName']?.toString() ?? '',
      about: json['about']?.toString() ?? '',
      cuisine: json['cuisine']?.toString() ?? '',
      address: RestaurantDetailsAddress.fromJson(json['address'] as Map<String, dynamic>? ?? {}),
      location: RestaurantDetailsLocation.fromJson(json['location'] as Map<String, dynamic>? ?? {}),
      amenities: RestaurantDetailsAmenities.fromJson(json['amenities'] as Map<String, dynamic>? ?? {}),
      contact: RestaurantDetailsContact.fromJson(json['contact'] as Map<String, dynamic>? ?? {}),
      halalInfo: RestaurantDetailsHalalInfo.fromJson(json['halalInfo'] as Map<String, dynamic>? ?? {}),
      policy: RestaurantDetailsPolicy.fromJson(json['policy'] as Map<String, dynamic>? ?? {}),
      status: RestaurantDetailsStatus.fromJson(json['status'] as Map<String, dynamic>? ?? {}),
      metrics: RestaurantDetailsMetrics.fromJson(json['metrics'] as Map<String, dynamic>? ?? {}),
      media: RestaurantDetailsMedia.fromJson(json['media'] as Map<String, dynamic>? ?? {}),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => RestaurantDetailsReview.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }

  // Helper getters for UI compatibility
  String get coverImage {
    if (media.restaurant.isNotEmpty) return media.restaurant.first.url;
    if (media.food.isNotEmpty) return media.food.first.url;
    return '';
  }

  List<String> get halalSummaryTags {
    return halalInfo.isCertified ? ['100% Halal', halalInfo.summary] : [halalInfo.summary];
  }

  String get formattedDistance {
    // API might not give distance in this endpoint, fallback to empty or calculate if location is there
    return '';
  }

  List<String> get photos {
    return media.food.map((e) => e.url).toList();
  }

  String get statusText => status.isOpen ? 'Open Now' : 'Closed';
  
  String get openingHours => '${status.openTime} - ${status.closeTime}';

  bool get isFavourite => false; // Fetching from somewhere else or wait for favorite API

  List<String> get availableAmenities {
    final list = <String>[];
    if (amenities.dineIn) list.add('Dine-in');
    if (amenities.takeaway) list.add('Takeaway');
    if (amenities.delivery) list.add('Delivery');
    if (amenities.reservationAvailable) list.add('Reservation');
    if (amenities.restroom) list.add('Restroom');
    if (amenities.outdoorSeating) list.add('Outdoor Seating');
    return list;
  }
}

class RestaurantDetailsAddress {
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String pincode;

  RestaurantDetailsAddress({
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory RestaurantDetailsAddress.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsAddress(
      fullAddress: json['fullAddress']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
    );
  }
}

class RestaurantDetailsLocation {
  final String type;
  final double latitude;
  final double longitude;

  RestaurantDetailsLocation({
    required this.type,
    required this.latitude,
    required this.longitude,
  });

  factory RestaurantDetailsLocation.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'] as List<dynamic>? ?? [];
    return RestaurantDetailsLocation(
      type: json['type']?.toString() ?? 'Point',
      longitude: coords.isNotEmpty ? (coords[0] as num).toDouble() : 0.0,
      latitude: coords.length > 1 ? (coords[1] as num).toDouble() : 0.0,
    );
  }
}

class RestaurantDetailsAmenities {
  final bool dineIn;
  final bool takeaway;
  final bool delivery;
  final bool reservationAvailable;
  final bool restroom;
  final bool outdoorSeating;

  RestaurantDetailsAmenities({
    required this.dineIn,
    required this.takeaway,
    required this.delivery,
    required this.reservationAvailable,
    required this.restroom,
    required this.outdoorSeating,
  });

  factory RestaurantDetailsAmenities.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsAmenities(
      dineIn: json['dineIn'] == true,
      takeaway: json['takeaway'] == true,
      delivery: json['delivery'] == true,
      reservationAvailable: json['reservationAvailable'] == true,
      restroom: json['restroom'] == true,
      outdoorSeating: json['outdoorSeating'] == true,
    );
  }
}

class RestaurantDetailsContact {
  final String phone;
  final Map<String, dynamic> socials;

  RestaurantDetailsContact({
    required this.phone,
    required this.socials,
  });

  factory RestaurantDetailsContact.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsContact(
      phone: json['phone']?.toString() ?? '',
      socials: json['socials'] as Map<String, dynamic>? ?? {},
    );
  }
}

class RestaurantDetailsHalalInfo {
  final bool isCertified;
  final String summary;

  RestaurantDetailsHalalInfo({
    required this.isCertified,
    required this.summary,
  });

  factory RestaurantDetailsHalalInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsHalalInfo(
      isCertified: json['isCertified'] == true,
      summary: json['summary']?.toString() ?? '',
    );
  }
}

class RestaurantDetailsPolicy {
  final String alcohol;

  RestaurantDetailsPolicy({required this.alcohol});

  factory RestaurantDetailsPolicy.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsPolicy(
      alcohol: json['alcohol']?.toString() ?? '',
    );
  }
}

class RestaurantDetailsStatus {
  final bool isOpen;
  final String openTime;
  final String closeTime;

  RestaurantDetailsStatus({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  factory RestaurantDetailsStatus.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'] as Map<String, dynamic>? ?? {};
    return RestaurantDetailsStatus(
      isOpen: json['isOpen'] == true,
      openTime: timings['open']?.toString() ?? '',
      closeTime: timings['close']?.toString() ?? '',
    );
  }
}

class RestaurantDetailsMetrics {
  final double avgRating;
  final int totalReviews;

  RestaurantDetailsMetrics({
    required this.avgRating,
    required this.totalReviews,
  });

  factory RestaurantDetailsMetrics.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsMetrics(
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
    );
  }
}

class RestaurantDetailsMedia {
  final List<MediaItem> food;
  final List<MediaItem> restaurant;

  RestaurantDetailsMedia({
    required this.food,
    required this.restaurant,
  });

  factory RestaurantDetailsMedia.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsMedia(
      food: (json['food'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      restaurant: (json['restaurant'] as List<dynamic>?)
              ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class MediaItem {
  final String url;
  final String publicId;
  final String uploadedAt;
  final bool isCover;

  MediaItem({
    required this.url,
    required this.publicId,
    required this.uploadedAt,
    required this.isCover,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      url: json['url']?.toString() ?? '',
      publicId: json['publicId']?.toString() ?? '',
      uploadedAt: json['uploadedAt']?.toString() ?? '',
      isCover: json['isCover'] == true,
    );
  }
}

class RestaurantDetailsReview {
  final String id;
  final ReviewUser user;
  final double rating;
  final String comment;
  final String createdAt;

  RestaurantDetailsReview({
    required this.id,
    required this.user,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory RestaurantDetailsReview.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsReview(
      id: json['_id']?.toString() ?? '',
      user: ReviewUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class ReviewUser {
  final String userName;
  final String imageUrl;

  ReviewUser({
    required this.userName,
    required this.imageUrl,
  });

  factory ReviewUser.fromJson(Map<String, dynamic> json) {
    final imageObj = json['image'] as Map<String, dynamic>? ?? {};
    return ReviewUser(
      userName: json['userName']?.toString() ?? '',
      imageUrl: imageObj['url']?.toString() ?? '',
    );
  }
}
