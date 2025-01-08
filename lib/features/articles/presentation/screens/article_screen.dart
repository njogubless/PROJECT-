// lib/articles/presentation/screens/article_screen.dart

import 'package:devotion/features/articles/presentation/providers/article_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article_entity.dart';

class ArticleScreen extends ConsumerWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  ArticleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articleListProvider);

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
                final newArticle = ArticleEntity(
                  id: DateTime.now().toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  createdAt: DateTime.now(),
                );
                ref.read(createArticleUseCaseProvider).call(newArticle);
                _titleController.clear();
                _contentController.clear();
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
                      subtitle: Text(article.content),
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
