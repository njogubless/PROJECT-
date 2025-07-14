import 'package:devotion/features/articles/presentation/providers/article_provider.dart';
import 'package:devotion/features/articles/presentation/screens/article_detail_screen.dart';
import 'package:devotion/services/bookmark_provider.dart';
import 'package:devotion/widget/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkedIds = ref.watch(bookmarkedArticlesProvider);
    final articlesAsync = ref.watch(articleStreamProvider);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
        ),
        body: articlesAsync.when(
          data: (articles) {
            final bookmarkedArticles = articles
                .where((article) => bookmarkedIds.contains(article.id))
                .toList();
      
            if (bookmarkedArticles.isEmpty) {
              return const Center(
                child: Text('No bookmarked articles yet'),
              );
            }
      
            return ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return ListTile(
                  title: Text(article.title),
              
                  trailing: BookmarkButton(articleId: article.id),
                  onTap: () {
                   
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(
                          articleId: article.id,
                        
                          title: article.title,
                          content: article.content,
                          isPublished: article.isPublished,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}