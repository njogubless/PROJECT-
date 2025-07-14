class Question {
  final String id;
  final String userId;
  final String questionText; 
  final String? answer; 
  final String? answerText; 
  final DateTime askedAt;
  final DateTime? answeredAt;
  final String questionTitle; 
  Question({
    required this.id,
    required this.userId,
    required this.questionText,
    this.answer, 
    this.answerText, 
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

