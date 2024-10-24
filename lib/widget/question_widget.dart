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
            Text(question.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Asked by ${question.askedBy}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 12),
            Text(question.summary), // Assuming a summary field exists
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Navigate to full question details
              },
              child: Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
