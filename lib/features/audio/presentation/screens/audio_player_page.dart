import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/providers/audio_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerPage extends ConsumerStatefulWidget {
  final AudioFile audioFile;

  const AudioPlayerPage({required this.audioFile, super.key});

  @override
  ConsumerState<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

// FIX: Changed `_AudioPlayerPageState` to extend ConsumerState (not State)
// so ref is available without needing ConsumerStatefulWidget's createState
// override to return a ConsumerState. The original used the old pattern with
// a plain State class name — this is consistent with flutter_riverpod ≥ 2.x.

class _AudioPlayerPageState extends ConsumerState<AudioPlayerPage> {
  @override
  void initState() {
    super.initState();
    // Auto-start playback when the page opens, matching typical player UX.
    // Wrapped in addPostFrameCallback so the provider is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioPlayerProvider.notifier).playAudio(
            // FIX (CRITICAL): Original code passed arguments in the wrong order:
            //   playAudio(audioFile.url, audioFile.title, audioFile.scripture)
            // Correct order is: playAudio(audioId, url, title)
            widget.audioFile.id,     // audioId
            widget.audioFile.url,    // url
            widget.audioFile.title,  // title
          );
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(audioPlayerProvider);
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.audioFile.title),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FIX: Show error banner if playback failed.
            if (playerState.error != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  playerState.error!,
                  style: TextStyle(color: Colors.red.shade700),
                  textAlign: TextAlign.center,
                ),
              ),
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
                      widget.audioFile.scripture,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    // FIX: Guard Slider max against 0 to avoid assertion error
                    // when duration hasn't loaded yet (max must be > 0).
                    Slider(
                      value: playerState.position.inSeconds
                          .toDouble()
                          .clamp(0, playerState.duration.inSeconds.toDouble()),
                      max: playerState.duration.inSeconds > 0
                          ? playerState.duration.inSeconds.toDouble()
                          : 1.0,
                      onChanged: playerState.duration.inSeconds > 0
                          ? (value) {
                              ref
                                  .read(audioPlayerProvider.notifier)
                                  .seekTo(Duration(seconds: value.toInt()));
                            }
                          : null,
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
                          onPressed: () =>
                              ref.read(audioPlayerProvider.notifier).seekTo(
                                    playerState.position -
                                        const Duration(seconds: 10),
                                  ),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            if (playerState.isPlaying) {
                              ref
                                  .read(audioPlayerProvider.notifier)
                                  .pauseAudio();
                            } else {
                              ref
                                  .read(audioPlayerProvider.notifier)
                                  .playAudio(
                                    // FIX: Correct argument order.
                                    widget.audioFile.id,
                                    widget.audioFile.url,
                                    widget.audioFile.title,
                                  );
                            }
                          },
                          child: Icon(
                            playerState.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: () =>
                              ref.read(audioPlayerProvider.notifier).seekTo(
                                    playerState.position +
                                        const Duration(seconds: 10),
                                  ),
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