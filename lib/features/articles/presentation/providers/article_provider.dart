// lib/articles/presentation/providers/article_providers.dart

import 'package:devotion/features/articles/data/repository/article_repository_impl.dart';
import 'package:devotion/features/articles/domain/entities/article_entity.dart';
import 'package:devotion/features/articles/domain/usecases/article_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final articleRepositoryProvider = Provider<ArticleRepositoryImpl>((ref) {
  return ArticleRepositoryImpl(FirebaseArticleDatasource());
});

// Use case providers
final createArticleUseCaseProvider = Provider<CreateArticle>((ref) {
  return CreateArticle(ref.watch(articleRepositoryProvider));
});

final getArticlesUseCaseProvider = Provider<GetArticles>((ref) {
  return GetArticles(ref.watch(articleRepositoryProvider));
});

// Article list provider
final articleListProvider = FutureProvider<List<ArticleEntity>>((ref) {
  return ref.watch(getArticlesUseCaseProvider).call();
});
