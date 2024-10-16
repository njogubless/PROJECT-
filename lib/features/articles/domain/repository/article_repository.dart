// article_repository.dart (Domain Layer)
abstract class ArticleRepository {
  Future<void> createArticle(ArticleEntity article);
  Future<List<ArticleEntity>> getArticles();
}
