import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devotion/widget/app_drawer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'name': 'Guest', 'email': 'guest@example.com', 'avatarUrl': ''};
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    return {
      'name': userDoc['name'] ?? 'User',
      'email': userDoc['email'] ?? user.email,
      'avatarUrl': userDoc['avatarUrl'] ?? '',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        final userName = snapshot.data?['name'] ?? 'Loading...';
        final userEmail = snapshot.data?['email'] ?? 'Loading...';
        final userAvatarUrl = snapshot.data?['avatarUrl'] ?? 'https://via.placeholder.com/150';

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Latest Audio'),
                _buildHorizontalListView(_sampleAudioItems(), Icons.audiotrack),
                const SizedBox(height: 20),
                _buildSectionHeader('Latest Articles'),
                _buildHorizontalListView(_sampleArticleItems(), Icons.article),
                const SizedBox(height: 20),
                _buildSectionHeader('Latest Questions'),
                _buildVerticalListView(_sampleQuestionItems()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHorizontalListView(List<String> items, IconData icon) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(right: 12),
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    items[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerticalListView(List<String> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Material(
          child: ListTile(
            leading: const Icon(Icons.question_answer, color: Colors.blue),
            title: Text(items[index]),
            subtitle: const Text("View Answer"),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  List<String> _sampleAudioItems() {
    return ["Motivation Talk", "Morning Devotion", "Peaceful Meditation"];
  }

  List<String> _sampleArticleItems() {
    return ["Faith and Courage", "Steps to Overcome Fear", "Walking by Faith"];
  }

  List<String> _sampleQuestionItems() {
    return ["What is faith?", "How to handle challenges?", "Tips on prayer life"];
  }
}
