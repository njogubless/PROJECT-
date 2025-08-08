import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SplitFileManagementScreen extends StatelessWidget {
  final String audioCollectionPath;
  final String bookCollectionPath;

  const SplitFileManagementScreen({
    super.key,
    required this.audioCollectionPath,
    required this.bookCollectionPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Management'),
      ),
      body: Row(
        children: [
          // Left section - Audio Files
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.blue.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.audiotrack, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Audio Files',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildFileSection(
                    collectionPath: audioCollectionPath,
                    fileType: 'audio',
                    emptyMessage: 'No audio files uploaded yet',
                  ),
                ),
              ],
            ),
          ),
          // Vertical divider
          Container(
            width: 1,
            color: Colors.grey.shade300,
          ),
          // Right section - Book Files
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    border: Border(
                      bottom: BorderSide(color: Colors.green.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.book, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      Text(
                        'Book Files',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildFileSection(
                    collectionPath: bookCollectionPath,
                    fileType: 'book',
                    emptyMessage: 'No book files uploaded yet',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileSection({
    required String collectionPath,
    required String fileType,
    required String emptyMessage,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionPath).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 8),
                Text('Error: ${snapshot.error}'),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final files = snapshot.data?.docs ?? [];

        if (files.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  fileType == 'audio' ? Icons.audiotrack_outlined : Icons.book_outlined,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  emptyMessage,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            final data = file.data() as Map<String, dynamic>;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                leading: _getFileIcon(fileType),
                title: Text(
                  data['fileName'] ?? 'Unnamed File',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uploaded: ${_formatDate(data['uploadDate'])}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Size: ${_formatFileSize(data['fileSize'] ?? 0)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () => _showDeleteConfirmation(
                    context,
                    file.id,
                    data['fileUrl'],
                    collectionPath,
                    data['fileName'] ?? 'this file',
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _getFileIcon(String fileType) {
    IconData iconData;
    Color color;

    switch (fileType.toLowerCase()) {
      case 'audio':
        iconData = Icons.audiotrack;
        color = Colors.blue;
        break;
      case 'book':
        iconData = Icons.book;
        color = Colors.green;
        break;
      default:
        iconData = Icons.insert_drive_file;
        color = Colors.grey;
    }
    return Icon(iconData, color: color, size: 20);
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';
    if (date is Timestamp) {
      final dateTime = date.toDate();
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
    return date.toString();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  void _showDeleteConfirmation(
    BuildContext context,
    String docId,
    String fileUrl,
    String collectionPath,
    String fileName,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete "$fileName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFile(context, docId, fileUrl, collectionPath);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFile(
    BuildContext context,
    String docId,
    String fileUrl,
    String collectionPath,
  ) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Delete from Storage
      await FirebaseStorage.instance.refFromURL(fileUrl).delete();

      // Delete from Firestore
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docId)
          .delete();

      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('File deleted successfully')),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }
}