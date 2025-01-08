// article_repository.dart (Domain Layer)
import 'package:devotion/features/articles/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  Future<void> createArticle(ArticleEntity article);
  Future<List<ArticleEntity>> getArticles();
}
