class QuestionModel {
  final String id;
  final String userId;
  final String question;
  final String? answer;
  final DateTime askedAt;
  final DateTime? answeredAt;

  QuestionModel({
    required this.id,
    required this.userId,
    required this.question,
    this.answer,
    required this.askedAt,
    this.answeredAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'question': question,
      'answer': answer,
      'askedAt': askedAt.toIso8601String(),
      'answeredAt': answeredAt?.toIso8601String(),
    };
  }

  static QuestionModel fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'],
      userId: map['userId'],
      question: map['question'],
      answer: map['answer'],
      askedAt: DateTime.parse(map['askedAt']),
      answeredAt: map['answeredAt'] != null ? DateTime.parse(map['answeredAt']) : null,
    );
  }
}
