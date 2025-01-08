import 'package:devotion/features/books/domain/usecases/upload_book_usecase.dart';
import 'package:devotion/features/books/presentation/book_upload_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookUploadNotifier extends StateNotifier<BookUploadState> {
  final UploadBookUseCase uploadBookUseCase;

  BookUploadNotifier(this.uploadBookUseCase) : super(BookUploadInitial());

  Future<void> uploadBook(book) async {
    state = BookUploadLoading();
    try {
      await uploadBookUseCase.execute(book);
      state = BookUploadSuccess();
    } catch (e) {
      state = BookUploadFailure(e.toString());
    }
  }
}
