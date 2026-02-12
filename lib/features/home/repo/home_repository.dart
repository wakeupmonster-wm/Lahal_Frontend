import 'package:lahal_application/features/home/model/restaurant_model.dart';

class HomeRepository {
  Future<List<RestaurantModel>> fetchBestRestaurants() async {
    // API calling setup (commented for now)
    /*
    final response = await _apiService.sendHttpRequest(
      url: AppUrls.home,
      method: HttpMethod.get,
    );
    if (response is List) {
      return response.map((e) => RestaurantModel.fromJson(e)).toList();
    }
    return [];
    */

    // Dummy data for currently
    await Future.delayed(const Duration(seconds: 2)); // Simulate API delay
    return [
      RestaurantModel(
        id: '1',
        name: 'Rose Garden Restaurant',
        address: 'Melbourne, VIC 3001',
        distance: '1.6 km',
        rating: 5.0,
        reviewCount: 120,
        status: 'Open now',
        openingHours: '11:30 AM to 11:00 PM',
        category: 'Middle Eastern restaurant',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
        description:
            'A beautiful garden restaurant serving authentic Middle Eastern cuisine.',
        halalSummary: ['100% Halal', 'No Alcohol'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
      RestaurantModel(
        id: '2',
        name: 'The Halal Guys',
        address: 'Sydney, NSW 2000',
        distance: '2.4 km',
        rating: 4.8,
        reviewCount: 350,
        status: 'Open now',
        openingHours: '10:00 AM to 12:00 AM',
        category: 'American Halal',
        imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=800',
        description: 'Famous NYC style halal platters and sandwiches.',
        halalSummary: ['Certified Halal'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
      RestaurantModel(
        id: '3',
        name: 'Rose Garden Restaurant',
        address: 'Melbourne, VIC 3001',
        distance: '1.6 km',
        rating: 5.0,
        reviewCount: 120,
        status: 'Open now',
        openingHours: '11:30 AM to 11:00 PM',
        category: 'Middle Eastern restaurant',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
        description:
            'A beautiful garden restaurant serving authentic Middle Eastern cuisine.',
        halalSummary: ['100% Halal', 'No Alcohol'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
      RestaurantModel(
        id: '4',
        name: 'The Halal Guys',
        address: 'Sydney, NSW 2000',
        distance: '2.4 km',
        rating: 4.8,
        reviewCount: 350,
        status: 'Open now',
        openingHours: '10:00 AM to 12:00 AM',
        category: 'American Halal',
        imageUrl:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&q=80&w=800',
        description: 'Famous NYC style halal platters and sandwiches.',
        halalSummary: ['Certified Halal'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
    ];
  }

  Future<List<RestaurantModel>> fetchFavoriteRestaurants() async {
    // Dummy data for currently
    await Future.delayed(const Duration(seconds: 2)); // Simulate API delay
    return [
      RestaurantModel(
        id: '1',
        name: 'Rose Garden Restaurant',
        address: 'Melbourne, VIC 3001',
        distance: '1.6 km',
        rating: 5.0,
        reviewCount: 120,
        status: 'Open now',
        openingHours: '11:30 AM to 11:00 PM',
        category: 'Middle Eastern restaurant',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
        description:
            'A beautiful garden restaurant serving authentic Middle Eastern cuisine.',
        halalSummary: ['100% Halal', 'No Alcohol'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
      RestaurantModel(
        id: '2',
        name: 'Rose Garden Restaurant',
        address: 'Melbourne, VIC 3001',
        distance: '1.6 km',
        rating: 5.0,
        reviewCount: 120,
        status: 'Open now',
        openingHours: '11:30 AM to 11:00 PM',
        category: 'Middle Eastern restaurant',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
        description:
            'A beautiful garden restaurant serving authentic Middle Eastern cuisine.',
        halalSummary: ['100% Halal', 'No Alcohol'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
      RestaurantModel(
        id: '3',
        name: 'Rose Garden Restaurant',
        address: 'Melbourne, VIC 3001',
        distance: '1.6 km',
        rating: 5.0,
        reviewCount: 120,
        status: 'Open now',
        openingHours: '11:30 AM to 11:00 PM',
        category: 'Middle Eastern restaurant',
        imageUrl:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&q=80&w=800',
        description:
            'A beautiful garden restaurant serving authentic Middle Eastern cuisine.',
        halalSummary: ['100% Halal', 'No Alcohol'],
        photos: [],
        amenities: {},
        reviews: [],
        socialConnects: SocialConnects(twitter: ""),
      ),
    ];
  }
}
