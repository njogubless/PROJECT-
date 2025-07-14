

import 'package:devotion/features/articles/domain/entities/article_entity.dart';
import 'package:devotion/features/articles/domain/repository/article_repository.dart';

class CreateArticle {
  final ArticleRepository repository;

  CreateArticle(this.repository);

  Future<void> call(ArticleEntity article) {
    return repository.createArticle(article);
  }
}


class GetArticles {
  final ArticleRepository repository;

  GetArticles(this.repository);

  Future<List<ArticleEntity>> call() async{
    return await repository.getArticles();
  }
}