import 'package:devotion/features/Q&A/domain/entities/question.dart';


abstract class QuestionRepository {
  Future<void> submitQuestion(Question question);
  Future<List<Question>> getQuestions();
  Future<void> answerQuestion(String questionId, String answerText);
}
