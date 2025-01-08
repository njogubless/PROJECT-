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

    try {
      await _audioPlayer.play(UrlSource(url));  // Play using UrlSource
      state = AudioPlayerState.playing();
    } catch (e) {
      // Handle the error
      state = AudioPlayerState.initial();
    }
  }

  Future<void> pause() async {
    try {
      await _audioPlayer.pause();  // Pause returns Future<void>
      state = AudioPlayerState.paused();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();  // Stop returns Future<void>
      state = AudioPlayerState.stopped();
    } catch (e) {
      // Handle error
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
