import 'package:carousel_slider/carousel_slider.dart';
import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:devotion/features/Q&A/presentation/providers/question_provider.dart';
import 'package:devotion/features/articles/domain/entities/article_entity.dart';
import 'package:devotion/features/articles/presentation/providers/article_provider.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/providers/audio_repository_provider.dart';
import 'package:devotion/widget/app_drawer.dart';
import 'package:devotion/widget/article_widget.dart';
import 'package:devotion/widget/question_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final latestAudioProvider = FutureProvider<List<AudioFile>>((ref) async {
  return await ref
      .watch(audioRepositoryProvider)
      .fetchAudioFiles(); // Multiple audios
});

final latestArticleProvider = FutureProvider<List<ArticleEntity>>((ref) async {
  return await ref.watch(articleRepositoryProvider).getArticles();
});

final latestQuestionProvider = FutureProvider<List<Question>>((ref) async {
  return await ref.watch(questionRepositoryProvider).getQuestions();
});

class  HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Add the AppDrawer here
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const AppDrawer(
        userName: 'John Doe', // Replace with actual user data
        userEmail: 'john.doe@example.com',
        userAvatarUrl: 'https://via.placeholder.com/150',
      ),
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with image background
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Text('Home', style: TextStyle(fontSize: 18.0)),
              background: Image.network(
                'https://via.placeholder.com/400x300', // Replace with a meaningful background image
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
                    // Latest Audio Section with Carousel
                    const Text(
                      'Latest Audio',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ref.watch(latestAudioProvider).when(
                          data: (audios) => _buildAudioCarousel(audios),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, _) => const Text('Error loading audio'),
                        ),
                    const SizedBox(height: 24),

                    // Latest Article Section
                    const Text(
                      'Latest Article',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ref.watch(latestArticleProvider).when(
                          data: (articles) => Column(
                            children: articles
                                .map((article) =>
                                    ArticleWidget(article: article))
                                .toList(),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, _) => const Text('Error loading articles'),
                        ),
                    const SizedBox(height: 24),

                    // Latest Question Section
                    const Text(
                      'Latest Question',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ref.watch(latestQuestionProvider).when(
                          data: (questions) => Column(
                            children: questions
                                .map((question) =>
                                    QuestionWidget(question: question))
                                .toList(),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (error, _) => const Text('Error loading questions'),
                        ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  // Carousel Slider for Audio
  Widget _buildAudioCarousel(List<AudioFile> audios) {
    return CarouselSlider.builder(
      itemCount: audios.length,
      itemBuilder: (context, index, realIdx) {
        final audio = audios[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.audiotrack, size: 50, color: Colors.teal),
                const SizedBox(height: 10),
                Text(audio.title,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('${audio.duration} mins'),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Trigger audio playback
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 180,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
      ),
    );
  }
}
