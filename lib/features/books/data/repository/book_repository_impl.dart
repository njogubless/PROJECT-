import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/books/data/models/book_model.dart';
import 'package:devotion/features/books/domain/repository/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  final FirebaseFirestore firestore;

  BookRepositoryImpl(this.firestore);

  @override
  Future<void> uploadBook(book) async {
    final bookModel = BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      description: book.description,
      fileUrl: book.fileUrl,
    );

    await firestore.collection('books').doc(book.id).set(bookModel.toMap());
  }

  @override
  Future<dynamic> getBooks(book) async {
    try {
      final snapshot = await firestore.collection('books').get();
      List<BookModel> books = snapshot.docs.map((doc) {
        return BookModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      return books; // Return the list of BookModel as dynamic
    } catch (e) {
      throw Exception('Failed to load books: $e');
    }
  }
}
