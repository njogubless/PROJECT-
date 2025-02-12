
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

