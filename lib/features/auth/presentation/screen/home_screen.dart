import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/articles/domain/entities/article_entity.dart';
import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:devotion/widget/app_drawer.dart';

final latestAudioProvider = FutureProvider<List<AudioFile>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('audios').get();
  return snapshot.docs.map((doc) => AudioFile.fromJson(doc.data())).toList();
});

final latestArticleProvider = FutureProvider<List<ArticleEntity>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('articles').get();
  return snapshot.docs.map((doc) => ArticleEntity.fromJson(doc.data())).toList();
});

final latestQuestionProvider = FutureProvider<List<Question>>((ref) async {
  final snapshot = await FirebaseFirestore.instance.collection('questions').get();
  return snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return {'$user.name': 'Guest', 'email': 'guest@example.com', 'avatarUrl': ''};
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
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
        final userAvatarUrl =
            snapshot.data?['avatarUrl'] ?? 'https://via.placeholder.com/150';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          drawer: AppDrawer(
            userName: userName,
            userEmail: userEmail,
            userAvatarUrl: userAvatarUrl,
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text(
                    'Home',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  background: Image.network(
                    'https://via.placeholder.com/400x300',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        context,
                        ref,
                        title: 'Latest Audio',
                        provider: latestAudioProvider,
                        itemBuilder: (audio) => _buildAudioCard(audio),
                        navigateTo: () {
                          Navigator.pushNamed(context, '/otherAudios');
                        },
                      ),
                      _buildSection(
                        context,
                        ref,
                        title: 'Latest Article',
                        provider: latestArticleProvider,
                        itemBuilder: (article) =>
                            _buildArticleCard(context, article),
                        navigateTo: () {
                          Navigator.pushNamed(context, '/otherArticles');
                        },
                      ),
                      _buildSection(
                        context,
                        ref,
                        title: 'Latest Question',
                        provider: latestQuestionProvider,
                        itemBuilder: (question) =>
                            _buildQuestionCard(context, question),
                        navigateTo: () {
                          Navigator.pushNamed(context, '/otherQuestions');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection<T>(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required FutureProvider<List<T>> provider,
    required Widget Function(T item) itemBuilder,
    required VoidCallback navigateTo,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: navigateTo,
              child: const Text(
                'See All',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ref.watch(provider).when(
              data: (items) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: items.map((item) => itemBuilder(item)).toList(),
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, _) => const Text('Error loading data'),
            ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAudioCard(AudioFile audio) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 200,
        child: Column(
          children: [
            const Icon(Icons.audiotrack, size: 40, color: Colors.teal),
            const SizedBox(height: 8),
            Text(
              audio.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                // Play audio logic here
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticleEntity article) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 200,
        child: Column(
          children: [
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to article details
              },
              child: const Text('Read More'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, Question question) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 200,
        child: Column(
          children: [
            Text(
              question.questionTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigate to question details
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
