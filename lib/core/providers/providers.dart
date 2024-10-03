// lib/features/audio/presentation/screens/audio_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_provider.dart';
import '../widgets/audio_tile.dart';

class AudioScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Audio Files')),
      body: audioState.when(
        data: (audioFiles) {
          if (audioFiles.isEmpty) {
            return Center(child: Text('No audio files found.'));
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
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
