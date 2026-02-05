class RestaurantModel {
  final String id;
  final String name;
  final String address;
  final String distance;
  final double rating;
  final int reviewCount;
  final String status; // e.g., "Open now"
  final String openingHours; // e.g., "11:30 AM to 11:00 PM"
  final String category; // e.g., "Middle Eastern restaurant"
  final String imageUrl;
  final String description;
  final List<String> halalSummary; // e.g., ["No alcohol"]
  final List<String> photos;
  final Map<String, bool> amenities; // e.g., {"Dine-in": true, "Takeout": true}
  final List<ReviewModel> reviews;
  final SocialConnects socialConnects;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.status,
    required this.openingHours,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.halalSummary,
    required this.photos,
    required this.amenities,
    required this.reviews,
    required this.socialConnects,
  });
}

class ReviewModel {
  final String userName;
  final String userImageUrl;
  final String date;
  final double rating;
  final String comment;

  ReviewModel({
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
  final String? twitter;

  SocialConnects({this.website, this.facebook, this.email, this.twitter});
}
