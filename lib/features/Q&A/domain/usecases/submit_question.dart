
import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:devotion/features/Q&A/domain/repository/question_repository.dart';

class SubmitQuestionUseCase {
  final QuestionRepository repository;

  SubmitQuestionUseCase(this.repository);

  Future<void> execute(Question question) async {
    await repository.submitQuestion(question);
  }
}
