import 'package:lahal_application/features/home/model/restaurant_model.dart';

class RestaurantRepository {
  Future<RestaurantModel> getRestaurantDetails(String id) async {
    // Mocking an API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return RestaurantModel(
      id: id,
      name: 'Rose Garden Restaurant',
      address: '28 Riverside Lane, Melbourne, VIC 3001, Australia',
      distance: '1.6 km away',
      rating: 5.0,
      reviewCount: 129,
      status: 'Open now',
      openingHours: '11:30 AM to 11:00 PM',
      category: 'Middle Eastern restaurant',
      imageUrl:
          'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
      description:
          'Experience the taste of Rose Garden Restaurant! We offer a delightful menu of halal dishes, prepared with fresh, high-quality ingredients and traditional recipes. From flavorful biryani to succulent curries, every meal is a culinary journey. Join us for a memorable dining experience in a welcoming atmosphere.',
      halalSummary: [
        'No alcohol',
        'No alcohol',
        'No alcohol',
      ], // Matching the repeated tags in screenshot
      photos: [
        'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1567620905732-2d1ec7bb7445?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1484723088339-fe2a7a8f1d31?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1473093226795-af9932fe5856?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&q=80&w=400',
        'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?auto=format&fit=crop&q=80&w=400',
      ],
      amenities: {
        'Dine-in': true,
        'Reservation Available': true,
        'Takeout': true,
        'Restroom': true,
        'Delivery': true,
        'Outdoor Seating': true,
      },
      reviews: [
        ReviewModel(
          userName: 'Johan Doe',
          userImageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&q=80&w=100',
          date: '1 year ago',
          rating: 5.0,
          comment:
              'First of all, most importantly the food cooked and delivered is delicious. they put in their b...more',
        ),
        ReviewModel(
          userName: 'Johan Doe',
          userImageUrl:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&q=80&w=100',
          date: '1 year ago',
          rating: 5.0,
          comment:
              'First of all, most importantly the food cooked and delivered is delicious.',
        ),
      ],
      socialConnects: SocialConnects(
        website: 'https://example.com',
        facebook: 'https://facebook.com',
        email: 'rose@example.com',
        twitter: 'https://twitter.com',
      ),
    );
  }
}
