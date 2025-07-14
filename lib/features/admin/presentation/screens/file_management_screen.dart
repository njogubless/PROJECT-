import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FileManagementScreen extends StatelessWidget {
  final String collectionPath;
  final String title;

  const FileManagementScreen({
    super.key,
    required this.collectionPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title Files'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(collectionPath).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final files = snapshot.data?.docs ?? [];

          if (files.isEmpty) {
            return const Center(child: Text('No files uploaded yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final data = file.data() as Map<String, dynamic>;
              
              return Card(
                child: ListTile(
                  leading: _getFileIcon(data['fileType'] ?? ''),
                  title: Text(data['fileName'] ?? 'Unnamed File'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Uploaded: ${_formatDate(data['uploadDate'])}'),
                      Text('Size: ${_formatFileSize(data['fileSize'] ?? 0)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteFile(context, file.id, data['fileUrl']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _getFileIcon(String fileType) {
    IconData iconData;
    switch (fileType.toLowerCase()) {
      case 'audio':
        iconData = Icons.audiotrack;
        break;
      case 'book':
        iconData = Icons.book;
        break;
      default:
        iconData = Icons.insert_drive_file;
    }
    return Icon(iconData);
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'Unknown date';
    if (date is Timestamp) {
      return date.toDate().toString().split('.')[0];
    }
    return date.toString();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _deleteFile(BuildContext context, String docId, String fileUrl) async {
    try {
     
      await FirebaseStorage.instance.refFromURL(fileUrl).delete();
      
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(docId)
          .delete();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting file: $e')),
      );
    }
  }
}