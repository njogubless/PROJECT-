<<<<<<< HEAD
// lib/features/audio/presentation/pages/audio_list_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/screens/audio_player_page.dart';
import 'package:devotion/features/audio/presentation/screens/audio_record_page.dart';
=======

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/screens/audio_player_page.dart';
import 'package:devotion/features/audio/presentation/screens/audio_recording_page.dart';
>>>>>>> d8dc86b ( making changes on the audio platform and book screen)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DevotionPage extends ConsumerWidget {
  const DevotionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Sermons'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecordAudioPage()),
            ),
          ),
        ],
      ),
<<<<<<< HEAD
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('DevotionPage').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recordings = snapshot.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final recording = AudioFile.fromJson(
                recordings[index].data() as Map<String, dynamic>
              );

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.audio_file),
                  ),
                  title: Text(recording.title),
                  subtitle: Text(recording.scripture ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // Navigate to audio player page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AudioPlayerPage(audioFile: recording),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
=======
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Devotion').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading recordings: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final recordings = snapshot.data?.docs ?? [];

            if (recordings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.audio_file,
                      size: 64,
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No recordings yet',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RecordAudioPage()),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Recording'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: recordings.length,
              itemBuilder: (context, index) {
                final recordingData = recordings[index].data() as Map<String, dynamic>;
                final recording = AudioFile.fromJson(recordingData);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.audio_file,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    title: Text(
                      recording.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(recording.scripture ?? 'No scripture reference'),
                        const SizedBox(height: 2),
                        Text(
                          'Duration: ${_formatDuration(recording.duration)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AudioPlayerPage(audioFile: recording),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
>>>>>>> d8dc86b ( making changes on the audio platform and book screen)
}