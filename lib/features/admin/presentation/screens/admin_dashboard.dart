import 'package:devotion/features/admin/presentation/admin_dashbaord_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
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
                  DashboardTile(
                    title: 'Upload Article',
                    iconPath: 'assets/icons/article.png',
                    route: '/uploadArticle',
                    isPending: false,
                  ),
                  DashboardTile(
                    title: 'Upload Audio',
                    iconPath: 'assets/icons/audio.png',
                    route: '/uploadAudio',
                    isPending: true,
                  ),
                  DashboardTile(
                    title: 'Upload Book',
                    iconPath: 'assets/icons/book.png',
                    route: '/uploadBook',
                    isPending: false,
                  ),
                  DashboardTile(
                    title: 'Answer Questions',
                    iconPath: 'assets/icons/questions.png',
                    route: '/answerQuestions',
                    isPending: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
