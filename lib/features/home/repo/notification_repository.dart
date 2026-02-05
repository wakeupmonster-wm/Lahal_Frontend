import 'package:lahal_application/features/home/model/notification_model.dart';

class NotificationRepository {
  Future<List<NotificationModel>> fetchNotifications() async {
    // In a real app, you would uncomment this:
    /*
    final response = await _apiService.sendHttpRequest(
      url: AppUrls.notifications,
      method: HttpMethod.get,
    );
    if (response is List) {
      return response.map((e) => NotificationModel.fromJson(e)).toList();
    }
    return [];
    */

    // Dummy data for now as per the UI image
    await Future.delayed(const Duration(seconds: 2)); // Simulating network lag
    return [
      NotificationModel(
        id: '1',
        title: 'New Halal Spot Near You',
        description: 'A halal restaurant just opened nearby. Take a look!',
        time: '08:29 AM',
      ),
      NotificationModel(
        id: '2',
        title: 'Top Rated by Locals',
        description: 'This place is getting amazing reviews. Rated 4.5+',
        time: '8 hrs ago',
        type: 'star',
      ),
      NotificationModel(
        id: '3',
        title: 'Open & Ready Now',
        description: 'A popular halal restaurant near you is open right now.',
        time: '1 week ago',
      ),
    ];
  }
}
