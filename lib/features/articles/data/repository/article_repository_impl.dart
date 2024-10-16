// lib/articles/data/repositories/article_repository_impl.dart

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDatasource remoteDatasource;

  ArticleRepositoryImpl(this.remoteDatasource);

  @override
  Future<void> createArticle(ArticleEntity article) async {
    final articleModel = ArticleModel(
      id: article.id,
      title: article.title,
      content: article.content,
      createdAt: article.createdAt,
    );
    await remoteDatasource.createArticle(articleModel);
  }

  @override
  Future<List<ArticleEntity>> getArticles() async {
    final articles = await remoteDatasource.getArticles();
    return articles
        .map((articleModel) => ArticleEntity(
              id: articleModel.id,
              title: articleModel.title,
              content: articleModel.content,
              createdAt: articleModel.createdAt,
            ))
        .toList();
  }
}
