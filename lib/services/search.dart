import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class SearchState {
  final List<Map<String, dynamic>> searchResults;
  final bool isSearching;
  final String searchQuery;
  final bool isLoading;

  SearchState({
    this.searchResults = const [],
    this.isSearching = false,
    this.searchQuery = '',
    this.isLoading = false,
  });

  SearchState copyWith({
    List<Map<String, dynamic>>? searchResults,
    bool? isSearching,
    String? searchQuery,
    bool? isLoading,
  }) {
    return SearchState(
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


class SearchNotifier extends StateNotifier<SearchState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SearchNotifier() : super(SearchState());

  void startSearch() {
    state = state.copyWith(isSearching: true);
  }

  void stopSearch() {
    state = state.copyWith(
      isSearching: false,
      searchQuery: '',
      searchResults: [],
    );
  }

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(searchResults: []);
      return;
    }

    state = state.copyWith(isLoading: true, searchQuery: query.toLowerCase());

    try {

      final articleResults = await _searchCollection('articles', query);
      

      final audioResults = await _searchCollection('audio', query);

      final bookResults = await _searchCollection('books', query);

      final allResults = [
        ...articleResults,
        ...audioResults,
        ...bookResults,
      ];

      allResults.sort((a, b) {
        final aDate = (a['createdAt'] as Timestamp).toDate();
        final bDate = (b['createdAt'] as Timestamp).toDate();
        return bDate.compareTo(aDate);
      });

      state = state.copyWith(
        searchResults: allResults,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Search error: $e');
      state = state.copyWith(
        searchResults: [],
        isLoading: false,
      );
    }
  }

  Future<List<Map<String, dynamic>>> _searchCollection(
    String collectionName, 
    String query
  ) async {
    final lowercaseQuery = query.toLowerCase();
    
    final titleSnapshot = await _firestore
        .collection(collectionName)
        .where('titleLowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('titleLowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    final tagSnapshot = await _firestore
        .collection(collectionName)
        .where('tags', arrayContains: lowercaseQuery)
        .get();

    final contentSnapshot = await _firestore
        .collection(collectionName)
        .where('descriptionLowercase', isGreaterThanOrEqualTo: lowercaseQuery)
        .where('descriptionLowercase', isLessThanOrEqualTo: lowercaseQuery + '\uf8ff')
        .get();

    final results = <String, Map<String, dynamic>>{};
    
    for (var doc in [...titleSnapshot.docs, ...tagSnapshot.docs, ...contentSnapshot.docs]) {
      results[doc.id] = {
        ...doc.data(),
        'id': doc.id,
        'type': collectionName,
      };
    }

    return results.values.toList();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});


class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  
  const SearchResultCard({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: _getLeadingIcon(result['type']),
        title: Text(result['title'] ?? 'Untitled'),
        subtitle: Text(result['description'] ?? ''),
        trailing: Text(
          result['type'].toString().toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 12,
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/${result['type']}_detail',
            arguments: result,
          );
        },
      ),
    );
  }

  Widget _getLeadingIcon(String type) {
    IconData iconData;
    switch (type) {
      case 'articles':
        iconData = Icons.article;
        break;
      case 'audio':
        iconData = Icons.audiotrack;
        break;
      case 'books':
        iconData = Icons.book;
        break;
      default:
        iconData = Icons.file_present;
    }
    return Icon(iconData);
  }
}


class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    if (searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (searchState.searchResults.isEmpty && searchState.searchQuery.isNotEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: searchState.searchResults.length,
      itemBuilder: (context, index) {
        return SearchResultCard(
          result: searchState.searchResults[index],
        );
      },
    );
  }
}