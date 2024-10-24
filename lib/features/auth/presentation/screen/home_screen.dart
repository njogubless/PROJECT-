
import 'package:devotion/features/Q&A/domain/entities/question.dart';
import 'package:devotion/features/Q&A/presentation/providers/question_provider.dart';
import 'package:devotion/features/articles/presentation/providers/article_provider.dart';
import 'package:devotion/features/audio/presentation/providers/audio_repository_provider.dart';
import 'package:devotion/widget/article_widget.dart';
import 'package:devotion/widget/question_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final latestAudioProvider = FutureProvider<List<Audio>>((ref) async {
  return await ref.watch(audioRepositoryProvider).getLatestAudios(); // Multiple audios
});

final latestArticleProvider = FutureProvider<Article>((ref) async {
  return await ref.watch(articleRepositoryProvider).getLatestArticle();
});

final latestQuestionProvider = FutureProvider<Question>((ref) async {
  return await ref.watch(questionRepositoryProvider).getLatestQuestion();
});

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with image background
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text('Home', style: TextStyle(fontSize: 18.0)),
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
                  Text(
                    'Latest Audio',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ref.watch(latestAudioProvider).when(
                        data: (audios) => _buildAudioCarousel(audios),
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (error, _) => Text('Error loading audio'),
                      ),
                  SizedBox(height: 24),

                  // Latest Article Section
                  Text(
                    'Latest Article',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ref.watch(latestArticleProvider).when(
                        data: (article) => ArticleWidget(article: article),
                        loading: () => CircularProgressIndicator(),
                        error: (error, _) => Text('Error loading article'),
                      ),
                  SizedBox(height: 24),

                  // Latest Question Section
                  Text(
                    'Latest Question',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ref.watch(latestQuestionProvider).when(
                        data: (question) => QuestionWidget(question: question),
                        loading: () => CircularProgressIndicator(),
                        error: (error, _) => Text('Error loading question'),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carousel Slider for Audio
  Widget _buildAudioCarousel(List<Audio> audios) {
    return CarouselSlider.builder(
      itemCount: audios.length,
      itemBuilder: (context, index, realIdx) {
        final audio = audios[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.audiotrack, size: 50, color: Colors.teal),
                SizedBox(height: 10),
                Text(audio.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(audio.duration.toString() + ' mins'),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    // Trigger audio playback
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Text('Play'),
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
