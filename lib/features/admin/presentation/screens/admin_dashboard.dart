// lib/admin/presentation/screens/admin_dashboard.dart

import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildDashboardTile(context, 'Upload Article', Icons.article, '/uploadArticle'),
          _buildDashboardTile(context, 'Upload Audio', Icons.audiotrack, '/uploadAudio'),
          _buildDashboardTile(context, 'Upload Book', Icons.book, '/uploadBook'),
          _buildDashboardTile(context, 'Answer Questions', Icons.question_answer, '/answerQuestions'),
        ],
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
