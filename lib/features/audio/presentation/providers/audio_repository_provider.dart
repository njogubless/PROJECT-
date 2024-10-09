// lib/features/audio/presentation/providers/audio_provider.dart

import 'package:devotion/features/audio/domain/entities/audio_file.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';
import 'package:devotion/features/audio/domain/usecases/fetch_audio_file.dart';
import 'package:devotion/features/audio/presentation/providers/fetch_audio_file_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// The provider for the AudioRepository
final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepository();  // Return an instance of the repository
});


// The provider responsible for fetching the audio files
final audioProvider = StateNotifierProvider<AudioNotifier, AsyncValue<List<AudioFile>>>((ref) {
  final fetchAudioFiles = ref.watch(fetchAudioFilesProvider);  // Using the fetchAudioFilesProvider here
  return AudioNotifier(fetchAudioFiles);
});

// The StateNotifier responsible for managing the state of the audio files
class AudioNotifier extends StateNotifier<AsyncValue<List<AudioFile>>> {
  final FetchAudioFiles fetchAudioFiles;

  AudioNotifier(this.fetchAudioFiles) : super(const AsyncLoading()) {
    _fetchAudioFiles();  // Automatically fetch audio files on initialization
  }

  Future<void> _fetchAudioFiles() async {
    try {
      final audioFiles = await fetchAudioFiles();  // Fetch the list of audio files
      state = AsyncValue.data(audioFiles);
    } catch (e,stack ) {
      state = AsyncValue.error(e,stack);  // Handle error if fetching fails
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();  // Show loading while refreshing
    await _fetchAudioFiles();
  }
}
