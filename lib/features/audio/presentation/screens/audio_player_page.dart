import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerPage extends ConsumerStatefulWidget {
  final AudioFile audioFile;

  const AudioPlayerPage({required this.audioFile, super.key});

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends ConsumerState<AudioPlayerPage> {

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }


  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audioFile.title),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.audioFile.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.audioFile.scripture ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Slider(
                      value: playerState.position.inSeconds.toDouble(),
                      max: playerState.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        ref.read(audioPlayerProvider.notifier)
                          .seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(playerState.position)),
                        Text(_formatDuration(playerState.duration)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          onPressed: () => ref.read(audioPlayerProvider.notifier)
                            .seekTo(playerState.position - const Duration(seconds: 10)),
                        ),
                        FloatingActionButton(
                          onPressed: () => playerState.isPlaying
                            ? ref.read(audioPlayerProvider.notifier).pauseAudio()
                            : ref.read(audioPlayerProvider.notifier).playAudio(
                                widget.audioFile.url,
                                widget.audioFile.title,
                                widget.audioFile.scripture,
                              ),
                          child: Icon(
                            playerState.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: () => ref.read(audioPlayerProvider.notifier)
                            .seekTo(playerState.position + const Duration(seconds: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
