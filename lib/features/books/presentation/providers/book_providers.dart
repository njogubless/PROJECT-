import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devotion/features/books/data/models/book_model.dart';

final firestoreProvider = Provider((ref) {
  return FirebaseFirestore.instance;
});

final booksProvider = FutureProvider<List<BookModel>>((ref) async {
  final firestore = ref.watch(firestoreProvider);

  try {
    final snapshot = await firestore.collection('books').get();

    print('Total books found: ${snapshot.docs.length}');

    for (var doc in snapshot.docs) {
      print('Book doc ID: ${doc.id}');
      print('Book doc data: ${doc.data()}');
    }

    return snapshot.docs
        .map((doc) {
          try {
            return BookModel.fromJson({
              ...doc.data(),
              'id': doc.id,
            });
          } catch (e) {
            print('Error parsing document ${doc.id}: $e');
            // Return null for failed parsing, filter out later
            return null;
          }
        })
        .where((book) => book != null)
        .cast<BookModel>()
        .toList();
  } catch (e) {
    print('Error fetching books: $e');
    throw 'Failed to fetch books: $e';
  }
});

final downloadedBooksProvider = StateProvider<Set<String>>((ref) => {});

final selectedBookProvider = StateProvider<BookModel?>((ref) => null);