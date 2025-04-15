// article_model.dart (Data Layer)
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool isPublished;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isPublished,
  });

  // To map from Firebase
  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['timestamp'] != null
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      isPublished: map['isPublished'] ?? false,
    );
  }

  // To map to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

// article_remote_datasource.dart
abstract class ArticleRemoteDatasource {
  Future<void> createArticle(ArticleModel article);
  Future<List<ArticleModel>> getArticles();
}

// firebase_article_datasource.dart (implements ArticleRemoteDatasource)
class FirebaseArticleDatasource implements ArticleRemoteDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createArticle(ArticleModel article) async {
    await _firestore
        .collection('articles')
        .doc(article.id as String?)
        .set(article.toMap());
  }

  @override
  Future<List<ArticleModel>> getArticles() async {
    final querySnapshot = await _firestore.collection('articles').get();
    return querySnapshot.docs
        .map((doc) => ArticleModel.fromMap(doc.data()))
        .toList();
  }
}
