// presentation/providers/audio_player_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});

class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentUrl;

  AudioPlayerNotifier() : super(AudioPlayerState.initial());

  Future<void> play(String url) async {
    if (_currentUrl != url) {
      await _audioPlayer.stop();  // Stop any currently playing audio
      _currentUrl = url;
    }
    
    final result = await _audioPlayer.play(url);
    if (result == 1) {
      state = AudioPlayerState.playing();
    }
  }

  Future<void> pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      state = AudioPlayerState.paused();
    }
  }

  Future<void> stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      state = AudioPlayerState.stopped();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

class AudioPlayerState {
  final bool isPlaying;
  final bool isPaused;

  AudioPlayerState({required this.isPlaying, required this.isPaused});

  factory AudioPlayerState.initial() => AudioPlayerState(isPlaying: false, isPaused: false);

  factory AudioPlayerState.playing() => AudioPlayerState(isPlaying: true, isPaused: false);

  factory AudioPlayerState.paused() => AudioPlayerState(isPlaying: false, isPaused: true);

  factory AudioPlayerState.stopped() => AudioPlayerState(isPlaying: false, isPaused: false);
}
