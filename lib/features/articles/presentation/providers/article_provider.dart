// lib/articles/presentation/providers/article_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:devotion/features/articles/data/models/article_model.dart';
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





// StreamProvider to fetch articles from Firestore
final articleProvider = StreamProvider<List<ArticleModel>>((ref) {
  return FirebaseFirestore.instance
      .collection(FirebaseConstants.articleCollection)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return ArticleModel.fromMap(data);
        }).toList();
      });
});
