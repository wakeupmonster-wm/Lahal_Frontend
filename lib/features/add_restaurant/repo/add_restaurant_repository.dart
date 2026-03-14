import '../model/add_restaurant_model.dart';

class AddRestaurantRepository {
  Future<bool> submitRestaurantRequest(AddRestaurantModel restaurant) async {
    // TODO: Implement actual API call with Multipart request for images
    // For now, simulating a network delay and success
    await Future.delayed(const Duration(seconds: 2));

    // Log data for "debugging" purposes as requested
    print("Submitting Restaurant: ${restaurant.toJson()}");
    print("Images to upload: ${restaurant.images.length}");

    return true;
  }
}
