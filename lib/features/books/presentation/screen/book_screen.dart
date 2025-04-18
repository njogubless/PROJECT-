import 'package:devotion/features/books/data/models/book_model.dart';
import 'package:devotion/features/books/data/repository/firebase_storage.dart';
import 'package:devotion/features/books/presentation/screen/book_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devotion/features/books/presentation/providers/book_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BookScreen extends ConsumerWidget {
  const BookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Library',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: booksAsync.when(
        data: (books) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return BookCard(book: book,);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error loading books: $err',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}

class BookCard extends ConsumerWidget {
  final BookModel book;

  const BookCard({super.key, required this.book});

  Future<void> _downloadBook(BuildContext context, WidgetRef ref) async {
    try {
      final storageService = ref.read(storageServiceProvider);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Downloading book...')),
      );
      
      final file = await storageService.downloadFile(
        book.storagePath, 
        '${book.title}.pdf'
      );
      
      // Update downloaded books tracking
      final downloadedBooks = ref.read(downloadedBooksProvider.notifier);
      downloadedBooks.update((state) => {...state, book.id});
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloaded = ref.watch(downloadedBooksProvider).contains(book.id);
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to book reader screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookReaderScreen(book: book),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 3/4,
                child: CachedNetworkImage(
                  imageUrl: book.coverUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.book),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Navigate to reader
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookReaderScreen(book: book),
                            ),
                          );
                        },
                        icon: const Icon(Icons.read_more),
                        label: const Text('Read'),
                      ),
                      IconButton(
                        icon: Icon(
                          isDownloaded ? Icons.check_circle : Icons.download,
                          color: isDownloaded ? Colors.green : null,
                        ),
                        onPressed: () => _downloadBook(context, ref),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

