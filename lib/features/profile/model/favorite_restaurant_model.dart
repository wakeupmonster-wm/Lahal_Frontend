import 'package:lahal_application/features/home/model/restaurant_model.dart';

class FavoriteRestaurantResponse {
  final bool success;
  final bool fromCache;
  final String message;
  final int count;
  final List<FavoriteRestaurantModel> data;

  FavoriteRestaurantResponse({
    required this.success,
    required this.fromCache,
    required this.message,
    required this.count,
    required this.data,
  });

  factory FavoriteRestaurantResponse.fromJson(Map<String, dynamic> json) =>
      FavoriteRestaurantResponse(
        success: json["success"],
        fromCache: json["fromCache"],
        message: json["message"],
        count: json["count"],
        data: List<FavoriteRestaurantModel>.from(
          json["data"].map((x) => FavoriteRestaurantModel.fromJson(x)),
        ),
      );
}

class FavoriteRestaurantModel {
  final String id;
  final String restaurantName;
  final String about;
  final String cuisine;
  final Address address;
  final Location location;
  final bool isHalalCertified;
  final String halalSummary;
  final String alcoholPolicy;
  final OpeningHours openingHours;
  final Rating rating;
  final List<FoodImage> foodsImages;
  final List<RestaurantImage> restaurantImages;
  final Amenities amenities;
  final List<dynamic> reviews;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double distanceInKm;

  FavoriteRestaurantModel({
    required this.id,
    required this.restaurantName,
    required this.about,
    required this.cuisine,
    required this.address,
    required this.location,
    required this.isHalalCertified,
    required this.halalSummary,
    required this.alcoholPolicy,
    required this.openingHours,
    required this.rating,
    required this.foodsImages,
    required this.restaurantImages,
    required this.amenities,
    required this.reviews,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.distanceInKm,
  });

  factory FavoriteRestaurantModel.fromJson(Map<String, dynamic> json) {
    // Halal info parsing
    final halalInfo = json["halalInfo"] ?? {};
    final isHalal =
        halalInfo["isCertified"] ?? json["isHalalCertified"] ?? false;
    final hSummary = halalInfo["summary"] ?? json["halalSummary"] ?? "";

    // Rating / Metrics parsing
    final metrics = json["metrics"] ?? {};
    final rt = json["rating"] ?? {};
    final avgRating =
        (metrics["avgRating"]?.toDouble() ?? rt["average"]?.toDouble() ?? 0.0);
    final totalRev = (metrics["totalReviews"] ?? rt["totalReviews"] ?? 0);

    // Distance parsing (handles "15.73 km far away")
    double dist = 0.0;
    final distVal = json["distanceInKm"];
    if (distVal is String) {
      try {
        final match = RegExp(r"(\d+\.?\d*)").firstMatch(distVal);
        if (match != null) {
          dist = double.parse(match.group(0)!);
        }
      } catch (_) {}
    } else if (distVal is num) {
      dist = distVal.toDouble();
    }

    // Address parsing (API sometimes returns an array of addresses)
    final addrJson = json["address"];
    Address address;
    if (addrJson is List && addrJson.isNotEmpty) {
      address = Address.fromJson(addrJson[0]);
    } else if (addrJson is Map<String, dynamic>) {
      address = Address.fromJson(addrJson);
    } else {
      address = Address(
        fullAddress: "",
        city: "",
        state: "",
        country: "",
        pincode: "",
      );
    }

    // Image parsing (API has restaurantImg as string)
    final List<RestaurantImage> restImages = [];
    if (json["restaurantImg"] != null && json["restaurantImg"] is String) {
      restImages.add(
        RestaurantImage(
          url: json["restaurantImg"],
          publicId: "",
          uploadedAt: DateTime.now(),
          isCover: true,
        ),
      );
    } else if (json["restaurantImages"] != null) {
      restImages.addAll(
        List<RestaurantImage>.from(
          json["restaurantImages"].map((x) => RestaurantImage.fromJson(x)),
        ),
      );
    }

    return FavoriteRestaurantModel(
      id: json["_id"] ?? "",
      restaurantName: json["restaurantName"] ?? "",
      about: json["about"] ?? "",
      cuisine: json["cuisine"] ?? "",
      address: address,
      location: Location.fromJson(json["location"] ?? {}),
      isHalalCertified: isHalal,
      halalSummary: hSummary,
      alcoholPolicy: json["alcoholPolicy"] ?? "",
      openingHours: OpeningHours.fromJson(json["openingHours"] ?? {}),
      rating: Rating(average: avgRating, totalReviews: totalRev),
      foodsImages: json["foodsImages"] != null
          ? List<FoodImage>.from(
              json["foodsImages"].map((x) => FoodImage.fromJson(x)),
            )
          : [],
      restaurantImages: restImages,
      amenities: Amenities.fromJson(json["amenities"] ?? {}),
      reviews: json["reviews"] != null
          ? List<dynamic>.from(json["reviews"].map((x) => x))
          : [],
      phone: json["phone"] ?? "",
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
      distanceInKm: dist,
    );
  }

  RestaurantModel toRestaurantModel() {
    return RestaurantModel(
      id: id,
      name: restaurantName,
      address: address.fullAddress,
      distance: '${distanceInKm.toStringAsFixed(1)} km',
      rating: rating.average,
      reviewCount: rating.totalReviews,
      status: openingHours.isOpenNow ? "Open now" : "Closed",
      openingHours: '${openingHours.openTime} to ${openingHours.closeTime}',
      category: cuisine,
      imageUrl: restaurantImages.isNotEmpty ? restaurantImages[0].url : "",
      description: about,
      halalSummary: [halalSummary, alcoholPolicy],
      photos: restaurantImages.map((e) => e.url).toList(),
      amenities: {
        "Dine-in": amenities.dineIn,
        "Takeaway": amenities.takeaway,
        "Delivery": amenities.delivery,
        "Reservation": amenities.reservationAvailable,
        "Restroom": amenities.restroom,
        "Outdoor Seating": amenities.outdoorSeating,
      },
      reviews: [],
      latitude: location.coordinates.length > 1 ? location.coordinates[1] : 0.0,
      longitude: location.coordinates.isNotEmpty
          ? location.coordinates[0]
          : 0.0,
      socialConnects: SocialConnects(twitter: ""),
      isFavorite: true,
    );
  }
}

class Address {
  final String fullAddress;
  final String city;
  final String state;
  final String country;
  final String pincode;

  Address({
    required this.fullAddress,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    fullAddress: json["fullAddress"] ?? "",
    city: json["city"] ?? "",
    state: json["state"] ?? "",
    country: json["country"] ?? "",
    pincode: json["pincode"] ?? "",
  );
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    if (json["coordinates"] != null) {
      return Location(
        type: json["type"] ?? "Point",
        coordinates: List<double>.from(
          json["coordinates"].map((x) => x.toDouble()),
        ),
      );
    } else if (json["lng"] != null && json["lat"] != null) {
      return Location(
        type: "Point",
        coordinates: [json["lng"].toDouble(), json["lat"].toDouble()],
      );
    }
    return Location(type: "Point", coordinates: []);
  }
}

class OpeningHours {
  final String openTime;
  final String closeTime;
  final bool isOpenNow;

  OpeningHours({
    required this.openTime,
    required this.closeTime,
    required this.isOpenNow,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openTime: json["openTime"] ?? "00:00",
    closeTime: json["closeTime"] ?? "00:00",
    isOpenNow: json["isOpenNow"] ?? false,
  );
}

class Rating {
  final double average;
  final int totalReviews;

  Rating({required this.average, required this.totalReviews});

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    average: json["average"]?.toDouble() ?? 0.0,
    totalReviews: json["totalReviews"] ?? 0,
  );
}

class FoodImage {
  final String url;
  final String publicId;
  final DateTime uploadedAt;
  final bool isCover;

  FoodImage({
    required this.url,
    required this.publicId,
    required this.uploadedAt,
    required this.isCover,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) => FoodImage(
    url: json["url"] ?? "",
    publicId: json["publicId"] ?? "",
    uploadedAt: json["uploadedAt"] != null
        ? DateTime.parse(json["uploadedAt"])
        : DateTime.now(),
    isCover: json["isCover"] ?? false,
  );
}

class RestaurantImage {
  final String url;
  final String publicId;
  final DateTime uploadedAt;
  final bool isCover;

  RestaurantImage({
    required this.url,
    required this.publicId,
    required this.uploadedAt,
    required this.isCover,
  });

  factory RestaurantImage.fromJson(Map<String, dynamic> json) =>
      RestaurantImage(
        url: json["url"] ?? "",
        publicId: json["publicId"] ?? "",
        uploadedAt: json["uploadedAt"] != null
            ? DateTime.parse(json["uploadedAt"])
            : DateTime.now(),
        isCover: json["isCover"] ?? false,
      );
}

class Amenities {
  final bool dineIn;
  final bool takeaway;
  final bool delivery;
  final bool reservationAvailable;
  final bool restroom;
  final bool outdoorSeating;

  Amenities({
    required this.dineIn,
    required this.takeaway,
    required this.delivery,
    required this.reservationAvailable,
    required this.restroom,
    required this.outdoorSeating,
  });

  factory Amenities.fromJson(Map<String, dynamic> json) => Amenities(
    dineIn: json["dineIn"] ?? false,
    takeaway: json["takeaway"] ?? false,
    delivery: json["delivery"] ?? false,
    reservationAvailable: json["reservationAvailable"] ?? false,
    restroom: json["restroom"] ?? false,
    outdoorSeating: json["outdoorSeating"] ?? false,
  );
}
