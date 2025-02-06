import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:devotion/core/constants/firebase_constants.dart';

class WriteArticleScreen extends StatefulWidget {
  const WriteArticleScreen({Key? key}) : super(key: key);

  @override
  State<WriteArticleScreen> createState() => _WriteArticleScreenState();
}

class _WriteArticleScreenState extends State<WriteArticleScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<int> _getSermonCount() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirebaseConstants.articleCollection)
        .get();
    return snapshot.docs.length;
  }

  Future<void> _submitArticle() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        final sermonCount = await _getSermonCount();
        final today = DateTime.now().toLocal();
        final formattedDate = '${today.day}/${today.month}/${today.year}';
        final dynamicTitle = 'Article for Sermon ${sermonCount + 1}, on $formattedDate';

        await FirebaseFirestore.instance.collection(FirebaseConstants.articleCollection).add({
          'title': dynamicTitle,
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
