import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionAnswerContainer extends ConsumerWidget {
  const QuestionAnswerContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6.0),
        ]
      ),
      child: const Text(
        'Q/A',style: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.bold
        ),
      )
    );
  }
}