enum HttpMethod { get, post, put, patch, delete }

enum SnackbarType { success, error, warning, info }

enum AuthEntryMode { phone, email }

enum RestaurantFilters { near_you, top_rated, open_now, certified, top_reviewed }

extension RestaurantFiltersExtension on RestaurantFilters {
  /// Returns the API query‑param value, or null for `near_you` (uses lat/lng instead).
  String? get filterValue {
    switch (this) {
      case RestaurantFilters.near_you:
        return null;
      case RestaurantFilters.top_rated:
        return 'top_rated';
      case RestaurantFilters.open_now:
        return 'open_now';
      case RestaurantFilters.certified:
        return 'certified';
      case RestaurantFilters.top_reviewed:
        return 'top_reviewed';
    }
  }

  /// Display label for UI
  String get label {
    switch (this) {
      case RestaurantFilters.near_you:
        return 'Near you';
      case RestaurantFilters.top_rated:
        return 'Top rated';
      case RestaurantFilters.open_now:
        return 'Open now';
      case RestaurantFilters.certified:
        return 'Certified';
      case RestaurantFilters.top_reviewed:
        return 'Top reviewed';
    }
  }
}