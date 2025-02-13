import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatefulWidget {
  final String articleId;
  final String articleTitle;

  const ArticleDetailScreen({Key? key, required this.articleId, required this.articleTitle}) : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  Future<void> _addComment() async {
    final comment = _commentController.text.trim();
    if (comment.isNotEmpty) {
      await FirebaseFirestore.instance.collection('comments').add({
        'articleId': widget.articleId,
        'comment': comment,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('article')
                    .doc(widget.articleId)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final article = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(article['content'], style: const TextStyle(fontSize: 16)),
                      const Divider(),
                      const Text("Comments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  );
                },
              ),
              SizedBox(
                height: 300, // Ensure a scrollable height for the list
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .where('articleId', isEqualTo: widget.articleId)
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final comments = snapshot.data!.docs;
                    if (comments.isEmpty) return const Text("No comments yet.");
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment['comment']),
                          subtitle: Text(comment['timestamp'] != null
                              ? (comment['timestamp'] as Timestamp).toDate().toString()
                              : 'Unknown Date'),
                        );
                      },
                    );
                  },
                ),
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Add a comment...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
