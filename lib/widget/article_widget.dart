import 'package:devotion/features/articles/data/models/article_model.dart';
import 'package:flutter/material.dart';

class ArticleWidget extends StatelessWidget {
  final ArticleModel article;
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
            Text(article.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('By ${article.author}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 12),
            Text(article.summary), // Assuming a summary field exists
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Navigate to full article
              },
              child: Text('Read more'),
            ),
          ],
        ),
      ),
    );
  }
}