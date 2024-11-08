import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  const QuestionWidget({required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text(question.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Asked by ${question.askedAt}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text(question.questionText), // Assuming a summary field exists
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Navigate to full question details
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
