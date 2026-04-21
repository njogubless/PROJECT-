import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// ============================================================
// STATE — plain immutable data class, no Riverpod dependency
// ============================================================

class AudioPlayerState {
  final bool isPlaying;
  final String currentAudioId;
  final String currentTitle;
  final Duration position;
  final Duration duration;
  final ProcessingState processingState;
  final String? error;

  const AudioPlayerState({
    this.isPlaying = false,
    this.currentAudioId = '',
    this.currentTitle = '',
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.processingState = ProcessingState.idle,
    this.error,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    String? currentAudioId,
    String? currentTitle,
    Duration? position,
    Duration? duration,
    ProcessingState? processingState,
    Object? error = _sentinel,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentAudioId: currentAudioId ?? this.currentAudioId,
      currentTitle: currentTitle ?? this.currentTitle,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      processingState: processingState ?? this.processingState,
      error: error == _sentinel ? this.error : error as String?,
    );
  }
}

const Object _sentinel = Object();

// ============================================================
// NOTIFIER — Riverpod 2.x Notifier (replaces StateNotifier)
// ============================================================

class AudioPlayerNotifier extends Notifier<AudioPlayerState> {
  late final AudioPlayer _player;

  @override
  AudioPlayerState build() {
    // build() replaces the constructor. Set up the player and
    // register a disposal callback via ref.onDispose.
    _player = AudioPlayer();

    _player.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        processingState: playerState.processingState,
      );
    });

    _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    ref.onDispose(() => _player.dispose());

    return const AudioPlayerState();
  }

  Future<void> playAudio(String audioId, String url, String title) async {
    try {
      state = state.copyWith(error: null);

      String downloadUrl;

      if (state.currentAudioId != audioId) {
        if (url.isNotEmpty &&
            url.startsWith('https://firebasestorage.googleapis.com')) {
          downloadUrl = url;
        } else {
          String fileName = audioId;
          if (!fileName.endsWith('.mp3')) fileName = '$fileName.mp3';

          final audioRef =
              FirebaseStorage.instance.ref().child('audio').child(fileName);
          downloadUrl = await audioRef.getDownloadURL();
        }

        await _player.stop();
        await _player.setUrl(downloadUrl);
        state = state.copyWith(
          currentAudioId: audioId,
          currentTitle: title,
          position: Duration.zero,
        );
      }

      await _player.play();
    } catch (e, stackTrace) {
      debugPrint('Error playing audio: $e\n$stackTrace');

      if (e.toString().contains('object-not-found')) {
        try {
          final audioRef =
              FirebaseStorage.instance.ref().child('audio').child(audioId);
          final fallbackUrl = await audioRef.getDownloadURL();
          await _player.stop();
          await _player.setUrl(fallbackUrl);
          state = state.copyWith(
            currentAudioId: audioId,
            currentTitle: title,
            position: Duration.zero,
          );
          await _player.play();
          return;
        } catch (e2) {
          debugPrint('Fallback also failed: $e2');
        }
      }

      state = state.copyWith(
        isPlaying: false,
        error: 'Failed to play audio. Please try again.',
      );
    }
  }

  Future<void> pauseAudio() async => _player.pause();

  Future<void> stopAudio() async {
    await _player.stop();
    state = const AudioPlayerState();
  }

  Future<void> seekTo(Duration position) async {
    if (state.currentAudioId.isEmpty) return;
    final clamped = position.isNegative ? Duration.zero : position;
    await _player.seek(clamped);
  }
}

// ============================================================
// PROVIDER
// ============================================================

final audioPlayerProvider =
    NotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
  AudioPlayerNotifier.new,
);