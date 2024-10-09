import 'package:devotion/features/books/domain/entities/book.dart';


abstract class BookRepository {
  Future<void> uploadBook(Book book);
}
