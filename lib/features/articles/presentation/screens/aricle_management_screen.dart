import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:devotion/features/admin/presentation/screens/writeArticle.dart';
import 'package:devotion/features/articles/presentation/screens/article_detail_screen.dart';
import 'package:flutter/material.dart';

class ArticleManagementScreen extends StatefulWidget {
  const ArticleManagementScreen({Key? key}) : super(key: key);

  @override
  State<ArticleManagementScreen> createState() => _ArticleManagementScreenState();
}

class _ArticleManagementScreenState extends State<ArticleManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WriteArticleScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirebaseConstants.articleCollection)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No articles found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? 'Untitled';
              final content = data['content'] ?? '';
              final isPublished = data['isPublished'] ?? false;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(
                    content.length > 50 ? '${content.substring(0, 50)}...' : content,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    
                      IconButton(
                        icon: Icon(
                          isPublished ? Icons.visibility : Icons.visibility_off,
                          color: isPublished ? Colors.green : Colors.grey,
                        ),
                        onPressed: () {
                          _togglePublishStatus(doc.id, !isPublished);
                        },
                        tooltip: isPublished ? 'Unpublish' : 'Publish',
                      ),
              
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditArticleScreen(
                                articleId: doc.id,
                                title: title,
                                content: content,
                              ),
                            ),
                          );
                        },
                      ),
                   
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmation(doc.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(
                          articleId: doc.id,
                          title: title,
                          content: content,
                          isPublished: isPublished,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _togglePublishStatus(String docId, bool newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.articleCollection)
          .doc(docId)
          .update({'isPublished': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus 
              ? 'Article published successfully' 
              : 'Article unpublished'
          ),
          backgroundColor: newStatus ? Colors.green : Colors.orange,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Article'),
        content: const Text('Are you sure you want to delete this article? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteArticle(docId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteArticle(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseConstants.articleCollection)
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article deleted successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting article: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}