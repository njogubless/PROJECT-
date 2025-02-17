import 'package:devotion/features/articles/presentation/providers/article_provider.dart';
import 'package:devotion/features/articles/presentation/screens/article_detail_screen.dart';
import 'package:devotion/widget/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlePage extends ConsumerStatefulWidget {
  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends ConsumerState<ArticlePage> {
  TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  Future<void> toggleBookmark(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = prefs.getStringList('bookmarkedArticles') ?? [];
    if (bookmarks.contains(articleId)) {
      bookmarks.remove(articleId);
    } else {
      bookmarks.add(articleId);
    }
    await prefs.setStringList('bookmarkedArticles', bookmarks);
  }

  @override
  Widget build(BuildContext context) {
    final articleList = ref.watch(articleStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ArticleSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: articleList.when(
        data: (articles) {
          final filteredArticles = articles
              .where((article) => article.title
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();

          return ListView.builder(
            itemCount: filteredArticles.length,
            itemBuilder: (context, index) {
              final article = filteredArticles[index];
              return ListTile(
                title: Text(article.title),
                subtitle: Text(
                  "Published on: ${article.createdAt.toLocal().toString().split(' ')[0]}",
                ),
              trailing: BookmarkButton(articleId: article.id),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ArticleDetailScreen(
                        articleId: article.id,
                        articleTitle: article.title,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class ArticleSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final articles = []; // Fetch articles filtered by query
    if (articles.isEmpty) {
      return Center(child: Text('No results found.'));
    }
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          title: Text(article.title),
          onTap: () {
            // Show article details
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                          articleId: article.id,
                          articleTitle: article.title,
                        )));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final articles = []; // Fetch articles filtered by query
    if (articles.isEmpty) {
      return Center(child: Text('No suggestions found.'));
    }
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return ListTile(
          title: Text(article.title),
          onTap: () {
            query = article.title;
          },
        );
      },
    );
  }
}
