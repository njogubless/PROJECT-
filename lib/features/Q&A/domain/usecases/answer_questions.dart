import 'package:devotion/features/Q&A/domain/repository/question_repository.dart';



class AnswerQuestionUseCase {
  final QuestionRepository repository;

  AnswerQuestionUseCase(this.repository);

  Future<void> execute(String questionId, String answerText) async {
    await repository.answerQuestion(questionId, answerText);
  }
}
