// // lib/articles/data/repositories/article_repository_impl.dart

// //import 'package:devotion/features/articles/data/datasources/firebase_datasource.dart';
// import 'package:devotion/features/articles/data/models/article_model.dart';
// import 'package:devotion/features/articles/domain/entities/article_entity.dart';
// import 'package:devotion/features/articles/domain/repository/article_repository.dart';

// class ArticleRepositoryImpl implements ArticleRepository {
//   final ArticleRemoteDatasource remoteDatasource;

//   ArticleRepositoryImpl(this.remoteDatasource);

//   @override
//   Future<void> createArticle(ArticleEntity article) async {
//     final articleModel = ArticleModel(
//       id: article.id,
//       title: article.title,
//       content: article.content,
//       createdAt: article.createdAt,
//     );
//     await remoteDatasource.createArticle(articleModel);
//   }

//   @override
//   Future<List<ArticleEntity>> getArticles() async {
//     final articles = await remoteDatasource.getArticles();
//     return articles
//         .map((articleModel) => ArticleEntity(
//               id: articleModel.id,
//               title: articleModel.title,
//               content: articleModel.content,
//               createdAt: articleModel.createdAt,
//             ))
//         .toList();
//   }
// }
