import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devotion/features/books/data/models/book_model.dart';

// Firestore provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Books provider - directly fetches from Firestore
final booksProvider = FutureProvider<List<BookModel>>((ref) async {
  final firestore = ref.watch(firestoreProvider);
  
  try {
    final snapshot = await firestore.collection('books').get();
    return snapshot.docs.map((doc) => BookModel.fromJson({
      ...doc.data(),
      'id': doc.id,
    })).toList();
  } catch (e) {
    throw 'Failed to fetch books: $e';
  }
});

// Book upload provider
final bookUploadProvider = FutureProvider.family<void, BookModel>((ref, book) async {
  final firestore = ref.watch(firestoreProvider);
  
  try {
    await firestore.collection('books').add(book.toJson());
  } catch (e) {
    throw 'Failed to upload book: $e';
  }
});

// Simple download tracking
final downloadedBooksProvider = StateProvider<Set<String>>((ref) => {});

// Selected book provider (optional - for book details view)
final selectedBookProvider = StateProvider<BookModel?>((ref) => null);