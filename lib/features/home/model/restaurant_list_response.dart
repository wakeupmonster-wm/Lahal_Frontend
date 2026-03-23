import 'package:lahal_application/features/home/model/restaurant_model.dart';

class RestaurantListResponse {
  final RestaurantMetadata metadata;
  final List<RestaurantModel> restaurants;

  const RestaurantListResponse({
    required this.metadata,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return RestaurantListResponse(
      metadata: RestaurantMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      restaurants: dataList
          .map((e) => RestaurantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RestaurantMetadata {
  final int page;
  final int limit;
  final int count;
  final String distanceRange;

  const RestaurantMetadata({
    required this.page,
    required this.limit,
    required this.count,
    required this.distanceRange,
  });

  factory RestaurantMetadata.fromJson(Map<String, dynamic> json) {
    return RestaurantMetadata(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      count: (json['count'] as num?)?.toInt() ?? 0,
      distanceRange: json['distanceRange']?.toString() ?? '',
    );
  }

  /// Returns true if there could be more data on next page
  bool get hasMore => count >= limit;
}
