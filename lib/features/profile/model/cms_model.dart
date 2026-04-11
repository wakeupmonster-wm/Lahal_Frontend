class CmsModel {
  final String title;
  final String content;

  CmsModel({required this.title, required this.content});

  factory CmsModel.fromJson(Map<String, dynamic> json) {
    // Handle different API key mappings for flexibility
    return CmsModel(
      title: json['title'] ?? json['name'] ?? '',
      content: json['description'] ?? json['content'] ?? '',
    );
  }

  factory CmsModel.empty() => CmsModel(title: '', content: '');
}
