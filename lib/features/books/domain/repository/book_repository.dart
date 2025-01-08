abstract class BookRepository {
  Future<void> uploadBook(book);
  Future<dynamic> getBooks(book);
}
