import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SearchResult>> searchContent(String query) async {
    if (query.isEmpty) return [];

    List<SearchResult> results = [];
    
    // Search in products collection
    final productsSnapshot = await _firestore
        .collection('products')
        .where('searchKeywords', arrayContains: query.toLowerCase())
        .get();

    for (var doc in productsSnapshot.docs) {
      results.add(
        SearchResult(
          id: doc.id,
          title: doc['name'],
          subtitle: doc['category'],
          type: 'product',
          routeName: '/product-details',
          routeArgs: {'productId': doc.id},
        ),
      );
    }

    // Add more collections to search through as needed
    // Example: orders, categories, etc.

    return results;
  }
}

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String type;
  final String routeName;
  final Map<String, dynamic> routeArgs;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.routeName,
    required this.routeArgs,
  });
}
