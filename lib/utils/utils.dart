import 'package:intl/intl.dart';

class Utils {
  // Create a function named parseDuration which returns Duration by parsing the duration
  static Duration parseDuration(String duration) {
    List<String> parts = duration.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    // Split seconds into integer and fractional parts
    List<String> secondsParts = parts[2].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = secondsParts.length > 1 ? int.parse(secondsParts[1].padRight(3, '0').substring(0, 3)) : 0;

    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
    );
  }

  static String formatDob(String apiDate) {
    try {
      // Parse the API date string into a DateTime object
      DateTime parsedDate = DateTime.parse(apiDate);

      // Format the date as "Month Day, Year"
      String formattedDate = DateFormat('MMMM d, y').format(parsedDate);

      return formattedDate;
    } catch (e) {
      // Handle any parsing errors
      print("Error formatting date: $e");
      return apiDate; // Return the original date if formatting fails
    }
  }

  // Function Returns String 2h 30m by parsing the duration
  static String parseDurationToHourMinutec(String time) {
    final duration = parseDuration(time);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String result;
    if (twoDigitHours == "00") {
      result = "$twoDigitMinutes mins";
    } else {
      result = "${twoDigitHours}h $twoDigitMinutes mins";
    }
    return result;
  }

  static String parseDurationToHourMinute(String totalMinutes) {
    int minutes = int.parse(totalMinutes);
    int hours = minutes ~/ 60; // Calculate full hours
    int remainingMinutes = minutes % 60; // Calculate remaining minutes

    if (hours > 0 && remainingMinutes > 0) {
      return "${hours}h $remainingMinutes mins";
    } else if (hours > 0) {
      return "$hours hours";
    } else {
      return "$remainingMinutes mins";
    }
  }

  /// Converts a string value in milliliters (ml) to liters (L).
  /// Example: "2500" -> 2.5, "500" -> 0.5
  static double mlToLiters(num mlValue) {
    // Convert ml to liters (1 liter = 1000 ml)
    return mlValue / 1000.0;
  }

  /// Converts a DateTime object into a string formatted as "h:mm a".
  /// Example: 5:30 PM, 4:30 AM
  static String formatTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  // Formate Progress
  static String formateProgress(num value) {
    if (value <= 100) {
      return value.toString();
    } else {
      return "100";
    }
  }
}
