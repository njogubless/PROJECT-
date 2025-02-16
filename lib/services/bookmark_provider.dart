import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final bookmarkedArticlesProvider =
    StateNotifierProvider<BookmarkNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BookmarkNotifier(prefs);
});

class BookmarkNotifier extends StateNotifier<List<String>> {
  final SharedPreferences _prefs;
  
  BookmarkNotifier(this._prefs) : super([]) {
    // Load saved bookmarks when initialized
    final savedBookmarks = _prefs.getStringList('bookmarkedArticles');
    if (savedBookmarks != null) {
      state = savedBookmarks;
    }
  }
  
  Future<void> toggleBookmark(String articleId) async {
    try {
      if (state.contains(articleId)) {
        // Remove bookmark
        state = state.where((id) => id != articleId).toList();
      } else {
        // Add bookmark
        state = [...state, articleId];
      }
      // Save to SharedPreferences
      await _prefs.setStringList('bookmarkedArticles', state);
    } catch (e) {
      print('Error toggling bookmark: $e');
      // You might want to show an error message to the user here
    }
  }
}