// lib/features/audio/presentation/widgets/audio_tile.dart

import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/providers/audio_player_provider.dart';
import 'package:devotion/features/audio/presentation/providers/download_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioTile extends ConsumerWidget {
  final AudioFile audioFile;

  const AudioTile({super.key, required this.audioFile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioPlayer = ref.watch(audioPlayerProvider);
    final downloadState = ref.watch(downloadProvider(audioFile.id));

    return ListTile(
      title: Text(audioFile.title),
      subtitle: Text('Uploaded on ${audioFile.uploadDate.toLocal()}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              try {
                // Ensure the audio file URL is available
                if (audioFile.url.isNotEmpty) {
                 
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Audio file URL is unavailable')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error playing audio: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: downloadState.status == DownloadStatus.downloading
                ? null
                : () {
                    ref
                        .read(downloadProvider(audioFile.id).notifier)
                        .download(audioFile.id);
                  },
          ),
          if (downloadState.status == DownloadStatus.downloading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          if (downloadState.status == DownloadStatus.success)
            const Icon(Icons.check, color: Colors.green),
          if (downloadState.status == DownloadStatus.failure)
            const Icon(Icons.error, color: Colors.red),
        ],
      ),
    );
  }
}
