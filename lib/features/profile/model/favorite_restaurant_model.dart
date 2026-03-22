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

  factory FavoriteRestaurantModel.fromJson(Map<String, dynamic> json) =>
      FavoriteRestaurantModel(
        id: json["_id"],
        restaurantName: json["restaurantName"],
        about: json["about"],
        cuisine: json["cuisine"],
        address: Address.fromJson(json["address"]),
        location: Location.fromJson(json["location"]),
        isHalalCertified: json["isHalalCertified"],
        halalSummary: json["halalSummary"],
        alcoholPolicy: json["alcoholPolicy"],
        openingHours: OpeningHours.fromJson(json["openingHours"]),
        rating: Rating.fromJson(json["rating"]),
        foodsImages: List<FoodImage>.from(
          json["foodsImages"].map((x) => FoodImage.fromJson(x)),
        ),
        restaurantImages: List<RestaurantImage>.from(
          json["restaurantImages"].map((x) => RestaurantImage.fromJson(x)),
        ),
        amenities: Amenities.fromJson(json["amenities"]),
        reviews: List<dynamic>.from(json["reviews"].map((x) => x)),
        phone: json["phone"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        distanceInKm: json["distanceInKm"]?.toDouble() ?? 0.0,
      );

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
      reviews: [], // Reviews mapping can be added if needed
      latitude: location.coordinates[1],
      longitude: location.coordinates[0],
      socialConnects: SocialConnects(twitter: ""), // Default values
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
    fullAddress: json["fullAddress"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    pincode: json["pincode"],
  );
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json["type"],
    coordinates: List<double>.from(
      json["coordinates"].map((x) => x.toDouble()),
    ),
  );
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
    openTime: json["openTime"],
    closeTime: json["closeTime"],
    isOpenNow: json["isOpenNow"],
  );
}

class Rating {
  final double average;
  final int totalReviews;

  Rating({required this.average, required this.totalReviews});

  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    average: json["average"]?.toDouble() ?? 0.0,
    totalReviews: json["totalReviews"],
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
    url: json["url"],
    publicId: json["publicId"],
    uploadedAt: DateTime.parse(json["uploadedAt"]),
    isCover: json["isCover"],
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
        url: json["url"],
        publicId: json["publicId"],
        uploadedAt: DateTime.parse(json["uploadedAt"]),
        isCover: json["isCover"],
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
    dineIn: json["dineIn"],
    takeaway: json["takeaway"],
    delivery: json["delivery"],
    reservationAvailable: json["reservationAvailable"],
    restroom: json["restroom"],
    outdoorSeating: json["outdoorSeating"],
  );
}
