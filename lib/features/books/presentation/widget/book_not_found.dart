// lib/features/books/presentation/widgets/book_not_found_widget.dart
import 'package:flutter/material.dart';

class BookNotFoundWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onDownload;
  final VoidCallback onStream;
  final VoidCallback onGoBack;

  const BookNotFoundWidget({
    super.key,
    required this.errorMessage,
    required this.onDownload,
    required this.onStream,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_download_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Book Not Downloaded',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'This book is not available offline. Choose an option below:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildActionButtons(),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildErrorContainer(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download),
          label: const Text('Download & Open'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onStream,
          icon: const Icon(Icons.stream),
          label: const Text('Stream Online'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: onGoBack,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Go Back'),
        ),
      ],
    );
  }

  Widget _buildErrorContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Text(
        errorMessage,
        style: TextStyle(
          color: Colors.red.shade700,
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}