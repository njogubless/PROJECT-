// lib/features/books/presentation/models/book_reader_state.dart
import 'dart:io';

enum BookReaderStatus {
  loading,
  downloading,
  fileNotFound,
  loaded,
  error,
}

class BookReaderState {
  final BookReaderStatus status;
  final File? pdfFile;
  final String errorMessage;
  final int currentPage;
  final int totalPages;

  const BookReaderState({
    this.status = BookReaderStatus.loading,
    this.pdfFile,
    this.errorMessage = '',
    this.currentPage = 0,
    this.totalPages = 0,
  });

  BookReaderState copyWith({
    BookReaderStatus? status,
    File? pdfFile,
    String? errorMessage,
    int? currentPage,
    int? totalPages,
  }) {
    return BookReaderState(
      status: status ?? this.status,
      pdfFile: pdfFile ?? this.pdfFile,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  // Convenience getters
  bool get isLoading => status == BookReaderStatus.loading;
  bool get isDownloading => status == BookReaderStatus.downloading;
  bool get isFileNotFound => status == BookReaderStatus.fileNotFound;
  bool get isLoaded => status == BookReaderStatus.loaded;
  bool get hasError => status == BookReaderStatus.error;
  bool get hasFile => pdfFile != null;
}