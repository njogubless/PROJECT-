import 'package:devotion/features/books/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/book_providers.dart';
import 'book_upload_state.dart';

class UploadBookPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fileUrlController = TextEditingController();

  UploadBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookUploadState = ref.watch(bookUploadNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the book title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the author';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _fileUrlController,
                decoration: const InputDecoration(labelText: 'File URL'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please upload the file URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final book = Book(
                      id: 'unique_id',  // You can generate using UUID
                      title: _titleController.text,
                      author: _authorController.text,
                      description: _descriptionController.text,
                      fileUrl: _fileUrlController.text,
                    );

                    ref.read(bookUploadNotifierProvider.notifier).uploadBook(book);
                  }
                },
                child: const Text('Upload Book'),
              ),
              const SizedBox(height: 20),
              if (bookUploadState is BookUploadLoading)
                const CircularProgressIndicator(),
              if (bookUploadState is BookUploadSuccess)
                const Text('Book uploaded successfully!'),
              if (bookUploadState is BookUploadFailure)
                Text('Error: ${bookUploadState.error}'),
            ],
          ),
        ),
      ),
    );
  }
}
