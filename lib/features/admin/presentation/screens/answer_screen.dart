// lib/admin/presentation/screens/answer_questions_screen.dart

import 'package:flutter/material.dart';

class AnswerQuestionsScreen extends StatelessWidget {
  // This would ideally come from your Firebase database
  final List<Map<String, String>> questions = [
    {'question': 'How to use the app?', 'user': 'John Doe'},
    {'question': 'Can I download audios?', 'user': 'Jane Smith'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Answer Questions')),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index]['question']!),
            subtitle: Text('Asked by: ${questions[index]['user']}'),
            trailing: IconButton(
              icon: Icon(Icons.reply),
              onPressed: () {
                // Navigate to answer screen with the selected question
              },
            ),
          );
        },
      ),
    );
  }
}
