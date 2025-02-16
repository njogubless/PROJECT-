import 'package:devotion/services/bookmark_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarkButton extends ConsumerWidget {
  final String articleId;

  const BookmarkButton({super.key, required this.articleId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarkedArticlesProvider
        .select((bookmarks) => bookmarks.contains(articleId)));

    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? Colors.blue : null,
      ),
      onPressed: () {
        ref.read(bookmarkedArticlesProvider.notifier).toggleBookmark(articleId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks',
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
