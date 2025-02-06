import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:devotion/core/constants/firebase_constants.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionPage> {
  final TextEditingController _questionController = TextEditingController();

  Future<void> _submitQuestion() async {
    final questionText = _questionController.text.trim();
    if (questionText.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection(FirebaseConstants.questionsCollection).add({
          'question': questionText,
          'askedAt': FieldValue.serverTimestamp(),
          'isAnswered': false,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question submitted successfully!')),
        );
        _questionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting question: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
    }
  }

  void _navigateToQuestionDetail(String questionId, String questionText) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionDetailPage(questionId: questionId, questionText: questionText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a Question')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ask your question:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: 'Enter your question here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitQuestion,
              child: const Text('Submit Question'),
            ),
            const SizedBox(height: 20),
            const Text('Previous Questions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(FirebaseConstants.questionsCollection).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final questions = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final questionId = question.id;
                      final questionText = question['question'];
                      return ListTile(
                        title: Text(questionText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _navigateToQuestionDetail(questionId, questionText),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionDetailPage extends StatelessWidget {
  final String questionId;
  final String questionText;

  const QuestionDetailPage({Key? key, required this.questionId, required this.questionText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(questionText, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Answer:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection(FirebaseConstants.answersCollection)
                  .where('questionId', isEqualTo: questionId)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final answers = snapshot.data!.docs;
                if (answers.isEmpty) {
                  return const Text('No answer available yet.', style: TextStyle(fontSize: 16, color: Colors.red));
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: answers.map((answer) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        answer['answer'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
