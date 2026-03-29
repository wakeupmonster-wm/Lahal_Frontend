class FaqModel {
  final String? id;
  final String question;
  final String answer;
  final String? createdAt;
  final String? updatedAt;
  bool isExpanded;

  FaqModel({
    this.id,
    required this.question,
    required this.answer,
    this.createdAt,
    this.updatedAt,
    this.isExpanded = false,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['_id'] ?? json['id'],
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
