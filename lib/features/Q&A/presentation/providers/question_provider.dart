import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/Q&A/data/repository/question_repository_impl.dart';
import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:devotion/features/Q&A/domain/usecases/answer_questions.dart';
import 'package:devotion/features/Q&A/domain/usecases/get_questions.dart';
import 'package:devotion/features/Q&A/domain/usecases/submit_question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionNotifier extends StateNotifier<List<Question>> {
  final SubmitQuestionUseCase submitQuestionUseCase;
  final GetQuestionsUseCase getQuestionsUseCase;
  final AnswerQuestionUseCase answerQuestionUseCase;

  QuestionNotifier(
    this.submitQuestionUseCase,
    this.getQuestionsUseCase,
    this.answerQuestionUseCase,
  ) : super([]);

  Future<void> submitQuestion(Question question) async {
    await submitQuestionUseCase.execute(question);
    await fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    state = await getQuestionsUseCase.execute();
  }

  Future<void> answerQuestion(String questionId, String answerText) async {
    await answerQuestionUseCase.execute(questionId, answerText);
    await fetchQuestions();
  }
}

final questionProvider = StateNotifierProvider<QuestionNotifier, List<Question>>(
  (ref) => QuestionNotifier(
    ref.watch(submitQuestionUseCaseProvider),
    ref.watch(getQuestionsUseCaseProvider),
    ref.watch(answerQuestionUseCaseProvider),
  ),
);


final questionRepositoryProvider = Provider<QuestionRepositoryImpl>((ref) {
  final firestore = FirebaseFirestore.instance;
  return QuestionRepositoryImpl(firestore);
}); 

final submitQuestionUseCaseProvider = Provider<SubmitQuestionUseCase>(
  (ref) {
    final repository = ref.watch(questionRepositoryProvider);
    return SubmitQuestionUseCase(repository);
  },
);

final getQuestionsUseCaseProvider = Provider<GetQuestionsUseCase>(
  (ref) {
    final repository = ref.watch(questionRepositoryProvider);
    return GetQuestionsUseCase(repository);
  },
);

final answerQuestionUseCaseProvider = Provider<AnswerQuestionUseCase>(
  (ref) {
    final repository = ref.watch(questionRepositoryProvider);
    return AnswerQuestionUseCase(repository);
  },
);
