import 'package:devotion/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final bookmarkedArticlesProvider = StateNotifierProvider<BookmarkNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return BookmarkNotifier(prefs);
});

class BookmarkNotifier extends StateNotifier<List<String>> {
  final SharedPreferences _prefs;
  
  BookmarkNotifier(this._prefs) : super([]) {
    _init();
  }
  
  void _init() {
    final savedBookmarks = _prefs.getStringList('bookmarkedArticles');
    if (savedBookmarks != null) {
      state = savedBookmarks;
    }
  }
  
  Future<void> toggleBookmark(String articleId) async {
    final newState = List<String>.from(state);
    if (state.contains(articleId)) {
      newState.remove(articleId);
    } else {
      newState.add(articleId);
    }
    state = newState;
    await _prefs.setStringList('bookmarkedArticles', newState);
  }
  
  bool isBookmarked(String articleId) {
    return state.contains(articleId);
  }
}