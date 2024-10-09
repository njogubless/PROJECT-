import 'package:devotion/features/Q&A/presentation/screens/admin_answer_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/question_provider.dart';
 // Import the admin answer form

class QuestionPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Questions')),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  question.answerText != null
                      ? Text('Answer: ${question.answerText}')
                      : AdminAnswerForm(
                          questionId: question.id,
                          currentAnswerText: question.answerText ?? '',
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
