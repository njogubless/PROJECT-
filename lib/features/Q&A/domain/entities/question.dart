class Question {
  final String id;
  final String userId;
  final String questionText; // Only keep this for the question text
  final String? answer; // Answer can be nullable
  final String? answerText; // If you need both, rename to avoid confusion
  final DateTime askedAt;
  final DateTime? answeredAt;
  final String questionTitle; // answeredAt can also be nullable

  Question({
    required this.id,
    required this.userId,
    required this.questionText,
    this.answer, // Nullable properties should not be required
    this.answerText, // Nullable properties should not be required
    required this.askedAt,
    this.answeredAt,
    required this.questionTitle,
  });




  factory Question.fromJson(Map<String, dynamic> json) {

    return Question(
      id: json['id'] as String,
      userId: json['userId'] as String,
      questionText: json['questionText'] as String,
      questionTitle: json['questionTitle'] as String,
      askedAt: DateTime.parse(json['askedAt'] as String),
      answer: json['answer'] as String?,
      answerText: json['answerText'] as String?,
      answeredAt: json['answeredAt'] != null ? DateTime.parse(json['answeredAt'] as String) : null,
    );

  }

}

