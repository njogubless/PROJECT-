import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/question_provider.dart';

class AdminAnswerForm extends ConsumerWidget {
  final String questionId; // The ID of the question to answer
  final String currentAnswerText; // Existing answer text (if any)

  AdminAnswerForm({
    Key? key,
    required this.questionId,
    required this.currentAnswerText,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pre-populate the controller if there is an existing answer
    if (currentAnswerText.isNotEmpty) {
      _answerController.text = currentAnswerText;
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _answerController,
            decoration: const InputDecoration(
              labelText: 'Answer',
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an answer';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final answerText = _answerController.text;

                // Call the answerQuestion method from the provider
                await ref.read(questionProvider.notifier).answerQuestion(questionId, answerText);

                // Clear the text field after submission
                _answerController.clear();

                // Show a success message (optional)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Answer submitted successfully!')),
                );
              }
            },
            child: const Text('Submit Answer'),
          ),
        ],
      ),
    );
  }
}
