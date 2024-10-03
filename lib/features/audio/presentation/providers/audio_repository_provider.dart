// lib/features/audio/presentation/providers/audio_provider.dart

import 'package:devotion/features/audio/domain/entities/audio_file.dart';
import 'package:devotion/features/audio/domain/usecases/fetch_audio_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final audioProvider = StateNotifierProvider<AudioNotifier, AsyncValue<List<AudioFile>>>((ref) {
  final fetchAudioFiles = ref.read(fetchAudioFilesProvider);
  return AudioNotifier(fetchAudioFiles);
});

class AudioNotifier extends StateNotifier<AsyncValue<List<AudioFile>>> {
  final FetchAudioFiles fetchAudioFiles;

  AudioNotifier(this.fetchAudioFiles) : super(const AsyncLoading()) {
    _fetchAudioFiles();
  }

  Future<void> _fetchAudioFiles() async {
    try {
      final audioFiles = await fetchAudioFiles();
      state = AsyncValue.data(audioFiles);
    } catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    await _fetchAudioFiles();
  }
}
