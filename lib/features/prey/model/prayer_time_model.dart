import 'package:flutter/material.dart';

class PrayerTimeModel {
  final String name;
  final String time; // "HH:mm"
  final bool isUpcoming;

  PrayerTimeModel({
    required this.name,
    required this.time,
    this.isUpcoming = false,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimeModel(
      name: json['name'] as String,
      time: json['time'] as String,
      isUpcoming: json['isUpcoming'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'time': time, 'isUpcoming': isUpcoming};
  }
}
