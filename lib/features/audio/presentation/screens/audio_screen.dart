// lib/features/audio/presentation/screens/audio_screen.dart

import 'package:devotion/features/audio/presentation/providers/audio_repository_provider.dart';
import 'package:devotion/features/audio/presentation/widgets/audio_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AudioScreen extends ConsumerWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Audio Files')),
      body: audioState.when(
        data: (audioFiles) {
          if (audioFiles.isEmpty) {
            return const Center(child: Text('No audio files found.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(audioProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: audioFiles.length,
              itemBuilder: (context, index) {
                final audioFile = audioFiles[index];
                return AudioTile(audioFile: audioFile);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
