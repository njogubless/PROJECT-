// lib/articles/data/datasources/article_remote_datasource.dart

abstract class ArticleRemoteDatasource {
  Future<void> createArticle(ArticleModel article);
  Future<List<ArticleModel>> getArticles();
}

// lib/articles/data/datasources/firebase_article_datasource.dart

class FirebaseArticleDatasource implements ArticleRemoteDatasource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> createArticle(ArticleModel article) async {
    await firestore.collection('articles').doc(article.id).set(article.toMap());
  }

  @override
  Future<List<ArticleModel>> getArticles() async {
    final querySnapshot = await firestore.collection('articles').get();
    return querySnapshot.docs
        .map((doc) => ArticleModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
