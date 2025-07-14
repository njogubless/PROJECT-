import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/Q&A/data/models/question_model.dart';
import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:devotion/features/Q&A/domain/repository/question_repository.dart';


class QuestionRepositoryImpl implements QuestionRepository {
  final FirebaseFirestore firestore;

  QuestionRepositoryImpl(this.firestore);

  @override
  Future<void> submitQuestion(Question question) async {
    final questionModel = QuestionModel(
      id: question.id,
      userId: question.userId,
      question: question.questionText,
      askedAt: question.askedAt,
      answer: question.answer,
      answeredAt: question.answeredAt,
      questionTitle: '',
    );
    await firestore.collection('questions').doc(question.id).set(questionModel.toMap());
  }

  @override
  Future<List<Question>> getQuestions({String? userId}) async {
    QuerySnapshot query;
    if (userId != null) {
     
      query = await firestore.collection('questions')
          .where('userId', isEqualTo: userId)
          .get();
    } else {
     
      query = await firestore.collection('questions').get();
    }

    return query.docs.map((doc) => QuestionModel.fromMap(doc.data()as Map<String, dynamic>).toEntity()).toList();
  }




  @override
 @override
Future<void> answerQuestion(String questionId, String answer) async {
  await firestore.collection('questions').doc(questionId).update({
    'answer': answer,
    'answeredAt': DateTime.now(),
  });
}

}
