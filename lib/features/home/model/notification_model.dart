class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final String? type; // Can be used for different icons/actions

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      type: json['type'],
    );
  }
}
