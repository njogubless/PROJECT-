// lib/features/audio/presentation/widgets/audio_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/audio_file.dart';
import '../providers/audio_player_provider.dart';
import '../providers/download_provider.dart';
import 'package:just_audio/just_audio.dart';

class AudioTile extends ConsumerWidget {
  final AudioFile audioFile;

  AudioTile({required this.audioFile});

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
            icon: Icon(Icons.play_arrow),
            onPressed: () async {
              try {
                await audioPlayer.setUrl(audioFile.url);
                audioPlayer.play();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error playing audio: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: downloadState.status == DownloadStatus.downloading
                ? null
                : () {
                    ref.read(downloadProvider(audioFile.id).notifier).download(audioFile.id);
                  },
          ),
          if (downloadState.status == DownloadStatus.downloading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          if (downloadState.status == DownloadStatus.success)
            Icon(Icons.check, color: Colors.green),
          if (downloadState.status == DownloadStatus.failure)
            Icon(Icons.error, color: Colors.red),
        ],
      ),
    );
  }
}