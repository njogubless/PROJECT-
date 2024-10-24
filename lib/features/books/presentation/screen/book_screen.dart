import 'package:devotion/features/books/domain/entities/book.dart';
import 'package:devotion/features/books/presentation/providers/book_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookScreen extends ConsumerWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  BookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the articles from FutureProvider
    final articlesAsync = ref.watch(articlesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            ElevatedButton(
              onPressed: () {
                final newArticle = BookEntity(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  // content: _contentController.text, // Assuming BookEntity has content field
                  // createdAt: DateTime.now(), // Add createdAt if needed
                  author: '', // Add author or remove if unnecessary
                  description: '',
                  fileUrl: '',
                );
                // Call the create article use case
                // ref.read(createArticleUseCaseProvider).call(newArticle);
                // _titleController.clear();
                // _contentController.clear();
              },
              child: const Text('Submit'),
            ),
            Expanded(
              child: articlesAsync.when(
                data: (articles) => ListView.builder(
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ListTile(
                      title: Text(article.title),
                      // subtitle: Text(article.content),  // Use this if content exists in BookEntity
                    );
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
