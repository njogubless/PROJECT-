// lib/features/books/presentation/screens/book_reader_screen.dart
import 'package:devotion/features/books/data/controllers/book_reader_controller.dart';
import 'package:devotion/features/books/data/models/book_model.dart';
import 'package:devotion/features/books/data/models/book_reader_state.dart';

import 'package:devotion/features/books/presentation/widget/book_not_found.dart';
import 'package:devotion/features/books/presentation/widget/common.dart';
import 'package:devotion/features/books/presentation/widget/pdf_view.dart';

import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookReaderScreen extends ConsumerWidget {
  final BookModel book;

  const BookReaderScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(bookReaderControllerProvider(book).notifier);
    final state = ref.watch(bookReaderControllerProvider(book));

    return Scaffold(
      appBar: _buildAppBar(context, controller),
      body: _buildBody(context, state, controller),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, BookReaderController controller) {
    return AppBar(
      title: Text(
        book.title.isNotEmpty ? book.title : 'Book Reader',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: controller.retry,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, BookReaderState state, BookReaderController controller) {
    switch (state.status) {
      case BookReaderStatus.loading:
        return const LoadingWidget(message: 'Loading PDF...');
      
      case BookReaderStatus.downloading:
        return const LoadingWidget(message: 'Downloading PDF...');
      
      case BookReaderStatus.fileNotFound:
        return BookNotFoundWidget(
          errorMessage: state.errorMessage,
          onDownload: () => _handleDownload(context, controller),
          onStream: () => _handleStream(context, controller),
          onGoBack: () => Navigator.pop(context),
        );
      
      case BookReaderStatus.error:
        return ErrorWidget(
          title: 'Failed to load PDF',
          message: state.errorMessage,
          onRetry: controller.retry,
          onGoBack: () => Navigator.pop(context),
        );
      
      case BookReaderStatus.loaded:
        if (state.hasFile) {
          return PdfViewerWidget(
            pdfFile: state.pdfFile!,
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            onPageChanged: controller.updatePageInfo,
            onRender: controller.updateTotalPages,
            onError: controller.handlePdfError,
            onPageError: (page, error) => controller.handlePageError(page ?? 0, error),
            onViewCreated: controller.handleViewCreated,
          );
        } else {
          return const EmptyStateWidget(
            title: 'PDF file not found',
            message: 'The PDF file could not be loaded.',
            icon: Icons.picture_as_pdf,
          );
        }
    }
  }

  void _handleDownload(BuildContext context, BookReaderController controller) {
    controller.downloadAndOpenFile().then((_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book downloaded successfully!')),
        );
      }
    }).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $error')),
        );
      }
    });
  }

  void _handleStream(BuildContext context, BookReaderController controller) {
    controller.streamFile().catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stream failed: $error')),
        );
      }
    });
  }
}