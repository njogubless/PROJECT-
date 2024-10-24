

import 'package:devotion/features/books/domain/entities/book.dart';
import 'package:devotion/features/books/domain/repository/book_repository.dart';

class UploadBookUseCase {
  final BookRepository repository;

  UploadBookUseCase(this.repository);

  Future<void> execute( book) async {
    return await repository.uploadBook(book);
  }
}
