import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devotion/core/constants/firebase_constants.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  Future<void> _uploadAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final storageRef = FirebaseStorage.instance.ref().child("audio/$fileName");

      try {
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection(FirebaseConstants.sermonCollection)
            .add({'title': fileName, 'url': downloadUrl, 'timestamp': FieldValue.serverTimestamp()});
        debugPrint('Audio file uploaded successfully: $downloadUrl');
      } catch (e) {
        debugPrint('Error uploading audio: $e');
      }
    }
  }

  Future<void> _uploadBookFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      final file = File(result.files.single.path!);
      final fileName = result.files.single.name;
      final storageRef = FirebaseStorage.instance.ref().child("books/$fileName");

      try {
        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection(FirebaseConstants.testimonyCollection)
            .add({'title': fileName, 'url': downloadUrl, 'timestamp': FieldValue.serverTimestamp()});
        debugPrint('Book file uploaded successfully: $downloadUrl');
      } catch (e) {
        debugPrint('Error uploading book: $e');
      }
    }
  }

  void _navigateToWriteArticle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WriteArticleScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/homeScreen', (route) => false);
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Manage your platform with these tools:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardTile(
                    context,
                    title: 'Upload Audio',
                    icon: Icons.audiotrack,
                    onTap: _uploadAudioFile,
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Upload Book',
                    icon: Icons.book,
                    onTap: _uploadBookFile,
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Write Article',
                    icon: Icons.article,
                    onTap: () => _navigateToWriteArticle(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WriteArticleScreen extends StatefulWidget {
  const WriteArticleScreen({Key? key}) : super(key: key);

  @override
  State<WriteArticleScreen> createState() => _WriteArticleScreenState();
}

class _WriteArticleScreenState extends State<WriteArticleScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _submitArticle() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection(FirebaseConstants.articleCollection).add({
          'title': title,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article submitted successfully!')),
        );
        _titleController.clear();
        _contentController.clear();
      } catch (e) {
        debugPrint('Error submitting article: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write Article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Article Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Article Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitArticle,
              child: const Text('Submit Article'),
            ),
          ],
        ),
      ),
    );
  }
}
