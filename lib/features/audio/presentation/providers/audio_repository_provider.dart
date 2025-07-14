

import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository_impl.dart';
import 'package:devotion/features/audio/domain/usecases/fetch_audio_file.dart';
import 'package:devotion/features/audio/presentation/providers/fetch_audio_file_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepositoryImpl(); 
});



final audioProvider = StateNotifierProvider<AudioNotifier, AsyncValue<List<AudioFile>>>((ref) {
  final fetchAudioFiles = ref.watch(fetchAudioFilesProvider); 
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
    } catch (e,stack ) {
      state = AsyncValue.error(e,stack); 
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();  
    await _fetchAudioFiles();
  }
}
