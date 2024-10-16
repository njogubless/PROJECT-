
// create_article_usecase.dart
class CreateArticle {
  final ArticleRepository repository;

  CreateArticle(this.repository);

  Future<void> call(ArticleEntity article) {
    return repository.createArticle(article);
  }
}

// get_articles_usecase.dart
class GetArticles {
  final ArticleRepository repository;

  GetArticles(this.repository);

  Future<List<ArticleEntity>> call() async{
    return await repository.getArticles();
  }
}