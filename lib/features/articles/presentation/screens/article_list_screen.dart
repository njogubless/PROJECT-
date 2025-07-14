import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'article_detail_screen.dart';

class ArticleListScreen extends StatelessWidget {
  const ArticleListScreen({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final articles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(article['title'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(article['timestamp'] != null
                      ? (article['timestamp'] as Timestamp).toDate().toString()
                      : 'Unknown Date'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        articleId: article.id,
                        
                        title: article['title'],
                        content: article['content'],
                        isPublished: article['isPublished'],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
