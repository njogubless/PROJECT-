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
      String downloadUrl;
      
      if (state.currentAudioId != audioId) {
        debugPrint("Audio ID: $audioId");
        debugPrint("Provided URL: $url");
        
        // Check if URL is already a download URL
        if (url.isNotEmpty && url.startsWith('https://firebasestorage.googleapis.com')) {
          downloadUrl = url;
          debugPrint("Using provided download URL: $downloadUrl");
        } else {
          // URL is empty or not a download URL, construct path from audioId
          // Based on your Firebase Storage structure: audio/filename.mp3
          String fileName = audioId;
          if (!fileName.endsWith('.mp3')) {
            fileName = '$fileName.mp3';
          }
          
          debugPrint("Constructing Firebase Storage path: audio/$fileName");
          
          final audioRef = FirebaseStorage.instance.ref().child("audio").child(fileName);
          downloadUrl = await audioRef.getDownloadURL();
          debugPrint("Fetched Download URL from Firebase: $downloadUrl");
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
      debugPrint('Error playing audio: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Try alternative approach if the first one fails
      if (!e.toString().contains('object-not-found')) {
        rethrow;
      }
      
      try {
        debugPrint("Trying alternative path approach...");
        // Try with the audioId as is (in case it already includes .mp3)
        final audioRef = FirebaseStorage.instance.ref().child("audio").child(audioId);
        final downloadUrl = await audioRef.getDownloadURL();
        debugPrint("Alternative approach succeeded: $downloadUrl");
        
        await _player.stop();
        await _player.setUrl(downloadUrl);
        state = state.copyWith(
          currentAudioId: audioId,
          currentTitle: title,
          position: Duration.zero,
        );
        await _player.play();
      } catch (e2) {
        debugPrint('Alternative approach also failed: $e2');
        // You might want to show an error message to the user here
      }
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