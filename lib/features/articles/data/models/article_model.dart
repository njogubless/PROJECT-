// article_model.dart (Data Layer)
class ArticleModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  // To map from Firebase
  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
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
    await _firestore.collection('articles').doc(article.id).set(article.toMap());
  }

  @override
  Future<List<ArticleModel>> getArticles() async {
    final querySnapshot = await _firestore.collection('articles').get();
    return querySnapshot.docs.map((doc) => ArticleModel.fromMap(doc.data())).toList();
  }
}

// article_repository_impl.dart (Data Layer)
class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource remoteDatasource;

  ArticleRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> createArticle(ArticleModel article) {
    return remoteDatasource.createArticle(article);
  }

  @override
  Future<List<ArticleModel>> getArticles() {
    return remoteDatasource.getArticles();
  }
}
