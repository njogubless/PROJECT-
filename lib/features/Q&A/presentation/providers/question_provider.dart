// // presentation/providers/question_provider.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final questionProvider = StateNotifierProvider<QuestionNotifier, AsyncValue<List<Question>>>((ref) {
//   return QuestionNotifier(ref.read(questionRepositoryProvider));
// });

// class QuestionNotifier extends StateNotifier<AsyncValue<List<Question>>> {
//   final QuestionRepository repository;

//   QuestionNotifier(this.repository) : super(const AsyncLoading());

//   Future<void> fetchQuestions() async {
//     try {
//       final questions = await repository.fetchQuestions();
//       state = AsyncValue.data(questions);
//     } catch (e) {
//       state = AsyncValue.error(e);
//     }
//   }
// }

// // presentation/screens/question_screen.dart
// class QuestionScreen extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final questionState = watch(questionProvider);

//     return Scaffold(
//       appBar: AppBar(title: Text('Questions')),
//       body: questionState.when(
//         data: (questions) {
//           return ListView.builder(
//             itemCount: questions.length,
//             itemBuilder: (context, index) {
//               final question = questions[index];
//               return ListTile(
//                 title: Text(question.content),
//                 subtitle: Text('Asked by: ${question.userId}'),
//               );
//             },
//           );
//         },
//         loading: () => CircularProgressIndicator(),
//         error: (e, _) => Text('Error: $e'),
//       ),
//     );
//   }
// }
