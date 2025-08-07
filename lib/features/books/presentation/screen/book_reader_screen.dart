import 'dart:io';
import 'package:devotion/features/books/data/models/book_model.dart';
import 'package:devotion/features/books/data/repository/firebase_storage.dart';
import 'package:devotion/features/books/presentation/providers/book_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class BookReaderScreen extends ConsumerStatefulWidget {
  final BookModel book;

  const BookReaderScreen({super.key, required this.book});

  @override
  ConsumerState<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends ConsumerState<BookReaderScreen> {
  File? _pdfFile;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${widget.book.title}.pdf';
      final file = File(filePath);

      if (await file.exists()) {
        setState(() {
          _pdfFile = file;
          _isLoading = false;
        });
      } else {
        final storageService = ref.read(storageServiceProvider);
        final downloadedFile = await storageService.downloadFile(
          widget.book.storagePath,
          '${widget.book.title}.pdf',
        );

        final downloadedBooks = ref.read(downloadedBooksProvider.notifier);
        downloadedBooks.update((state) => {...state, widget.book.id});

        setState(() {
          _pdfFile = downloadedFile;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load PDF: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFile,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadFile,
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                )
              : _pdfFile != null
                  ? PDFView(
                      filePath: _pdfFile!.path,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: false,
                      onError: (error) {
                        setState(() {
                          _errorMessage = error.toString();
                        });
                      },
                      onRender: (_pages) {
                        setState(() {});
                      },
                    )
                  : const Center(child: Text('PDF file not found')),
    );
  }
}
