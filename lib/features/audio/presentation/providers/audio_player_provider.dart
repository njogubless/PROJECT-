import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerState {
  final bool isPlaying;
  final String currentAudioId;
  final String currentTitle;
  final Duration position;
  final Duration duration;
  final ProcessingState processingState;

  AudioPlayerState({
    this.isPlaying = false,
    this.currentAudioId = '',
    this.currentTitle = '',
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.processingState = ProcessingState.idle,
  });

  AudioPlayerState copyWith({
    bool? isPlaying,
    String? currentAudioId,
    String? currentTitle,
    Duration? position,
    Duration? duration,
    ProcessingState? processingState,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentAudioId: currentAudioId ?? this.currentAudioId,
      currentTitle: currentTitle ?? this.currentTitle,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      processingState: processingState ?? this.processingState,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayerNotifier() : super(AudioPlayerState()) {
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
  }

  Future<void> playAudio(String audioId, String url, String title) async {
    try {
      if (state.currentAudioId != audioId) {
        print("URL: $url");
        final storageRef = FirebaseStorage.instance.ref().child("Audios");
        print("${await storageRef.listAll()}");
        // .child("Audios/$url")
        // .getDownloadURL();

        await _player.stop();
        await _player.setUrl(
            "https://firebasestorage.googleapis.com/v0/b/reflection-of-faith.firebasestorage.app/o/Audios%2Fjaci.mp3?alt=media&token=307d2abf-766d-4b0f-9541-224a65d64e85");
        state = state.copyWith(
          currentAudioId: audioId,
          currentTitle: title,
          position: Duration.zero,
        );
      }
      await _player.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> pauseAudio() async {
    await _player.pause();
  }

  Future<void> stopAudio() async {
    await _player.stop();
    state = state.copyWith(
      isPlaying: false,
      currentAudioId: '',
      currentTitle: '',
      position: Duration.zero,
      duration: Duration.zero,
    );
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final audioPlayerProvider =
    StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});
