import 'package:devotion/features/books/data/models/book_model.dart';
import 'package:devotion/features/books/data/repository/firebase_storage.dart';
import 'package:devotion/features/books/presentation/screen/book_reader_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devotion/features/books/presentation/providers/book_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            return BookCard(
              book: book,
            );
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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final storageService = ref.read(storageServiceProvider);

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Downloading book...')),
      );

      String downloadPath = book.downloadUrl.isNotEmpty 
          ? book.downloadUrl 
          : book.fileUrl;
          
      if (downloadPath.isEmpty) {
        throw 'No download URL available for this book';
      }

      final fileName = book.fileName ?? '${book.title}.pdf';
      final file = await storageService.downloadFile(book.storagePath, fileName);

      final downloadedBooks = ref.read(downloadedBooksProvider.notifier);
      downloadedBooks.update((state) => {...state, book.id});

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Book downloaded successfully!')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
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
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: book.coverUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => _buildFallbackCover(),
                        )
                      : _buildFallbackCover(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title.isNotEmpty ? book.title : 'Unknown Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.author.isNotEmpty && book.author != 'Unknown Author')
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookReaderScreen(book: book),
                              ),
                            );
                          },
                          icon: const Icon(Icons.read_more, size: 18),
                          label: const Text('Read', style: TextStyle(fontSize: 12)),
                        ),
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

  Widget _buildFallbackCover() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            book.title.isNotEmpty ? book.title : 'Book',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}