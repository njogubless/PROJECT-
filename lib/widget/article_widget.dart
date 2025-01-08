
import 'package:devotion/features/articles/domain/entities/article_entity.dart';
import 'package:flutter/material.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleEntity article;
  const ArticleWidget({required this.article});

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
            Text(article.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // SizedBox(height: 8),
            // Text('By ${article.author}', style: TextStyle(color: Colors.grey)),
            // Assuming a summary field exists
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Navigate to full article
              },
              child: const Text('Read more'),
            ),
          ],
        ),
      ),
    );
  }
}
