import 'package:devotion/features/admin/presentation/screens/Adminquestionscreen.dart';
import 'package:devotion/features/admin/presentation/screens/writeArticle.dart';
import 'package:flutter/material.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:devotion/features/admin/presentation/screens/upload_files.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isUploading = false;

  Future<void> uploadFile(String collectionPath, String firebasePath) async {
    setState(() => _isUploading = true);
    try {
      await UploadFiles.uploadFileToFirebase(collectionPath, firebasePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
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
                    onTap: () => uploadFile(
                      FirebaseConstants.sermonCollection,
                      'audio',
                    ),
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Upload Book',
                    icon: Icons.book,
                    onTap: () => uploadFile(
                      FirebaseConstants.testimonyCollection,
                      'books',
                    ),
                  ),
                  _buildDashboardTile(
                    context,
                    title: 'Write Article',
                    icon: Icons.article,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WriteArticleScreen()),
                    ),  // Navigate to the new screen
                  ),
                  _buildDashboardTile(
                    context, 
                    title:'Manage Q/A', 
                    icon: Icons.question_answer_rounded, 
                    onTap: () => Navigator.push(
                      context,MaterialPageRoute(builder: (context) => AdminQuestionScreen())),)
                ],
              ),
            ),
            if (_isUploading) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              )
            ]
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
