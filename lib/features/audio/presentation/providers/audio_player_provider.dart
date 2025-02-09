// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:audioplayers/audioplayers.dart';

// final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
//   return AudioPlayerNotifier();
// });

// class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   String? _currentUrl;

//   AudioPlayerNotifier() : super(AudioPlayerState.initial());

//   Future<void> play(String url) async {
//     if (_currentUrl != url) {
//       await _audioPlayer.stop();  // Stop any currently playing audio
//       _currentUrl = url;
//     }

//     try {
//       await _audioPlayer.play(UrlSource(url));  // Play using UrlSource
//       state = AudioPlayerState.playing();
//     } catch (e) {
//       // Handle the error
//       state = AudioPlayerState.initial();
//     }
//   }

//   Future<void> pause() async {
//     try {
//       await _audioPlayer.pause();  // Pause returns Future<void>
//       state = AudioPlayerState.paused();
//     } catch (e) {
//       // Handle error
//     }
//   }

//   Future<void> stop() async {
//     try {
//       await _audioPlayer.stop();  // Stop returns Future<void>
//       state = AudioPlayerState.stopped();
//     } catch (e) {
//       // Handle error
//     }
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
// }

// class AudioPlayerState {
//   final bool isPlaying;
//   final bool isPaused;

//   AudioPlayerState({required this.isPlaying, required this.isPaused});

//   factory AudioPlayerState.initial() => AudioPlayerState(isPlaying: false, isPaused: false);

//   factory AudioPlayerState.playing() => AudioPlayerState(isPlaying: true, isPaused: false);

//   factory AudioPlayerState.paused() => AudioPlayerState(isPlaying: false, isPaused: true);

//   factory AudioPlayerState.stopped() => AudioPlayerState(isPlaying: false, isPaused: false);
// }

import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioPlayerState {
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isBuffering;
  final String? error;
  
  AudioPlayerState({
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.isBuffering = false,
    this.error,
  });

  AudioPlayerState copyWith({
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    bool? isBuffering,
    String? error,
  }) {
    return AudioPlayerState(
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      error: error ?? this.error,
    );
  }
}

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _player;
  bool _hasInitialized = false;

  AudioPlayerNotifier() : _player = AudioPlayer(), super(AudioPlayerState()) {
    _init();
  }

  void _init() {
    // Listen to player state changes
    _player.playerStateStream.listen((playerState) {
      state = state.copyWith(
        isPlaying: playerState.playing,
        isBuffering: playerState.processingState == ProcessingState.buffering,
      );
    });

    // Listen to position changes
    _player.positionStream.listen((position) {
      state = state.copyWith(position: position);
    });

    // Listen to duration changes
    _player.durationStream.listen((duration) {
      if (duration != null) {
        state = state.copyWith(duration: duration);
      }
    });

    // Listen to errors
    _player.playbackEventStream.listen(
      (event) {},
      onError: (Object e, StackTrace st) {
        state = state.copyWith(error: e.toString());
      },
    );
  }

  Future<void> loadAudio(String url) async {
    try {
      state = state.copyWith(isBuffering: true, error: null);
      await _player.setUrl(url);
      state = state.copyWith(isBuffering: false);
      _hasInitialized = true;
    } catch (e) {
      state = state.copyWith(
        isBuffering: false,
        error: 'Error loading audio: ${e.toString()}',
      );
    }
  }

  Future<void> play() async {
    try {
      if (!_hasInitialized) return;
      await _player.play();
    } catch (e) {
      state = state.copyWith(error: 'Error playing audio: ${e.toString()}');
    }
  }

  Future<void> pause() async {
    try {
      if (!_hasInitialized) return;
      await _player.pause();
    } catch (e) {
      state = state.copyWith(error: 'Error pausing audio: ${e.toString()}');
    }
  }

  Future<void> seekTo(Duration position) async {
    try {
      if (!_hasInitialized) return;
      await _player.seek(position);
    } catch (e) {
      state = state.copyWith(error: 'Error seeking audio: ${e.toString()}');
    }
  }

  Future<void> stop() async {
    try {
      if (!_hasInitialized) return;
      await _player.stop();
    } catch (e) {
      state = state.copyWith(error: 'Error stopping audio: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});