import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository_impl.dart';
import 'package:devotion/features/audio/domain/usecases/fetch_audio_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepositoryImpl();
});

final fetchAudioFilesProvider = Provider<FetchAudioFiles>((ref) {
  return FetchAudioFiles(ref.watch(audioRepositoryProvider));
});

final currentAudioProvider = StateProvider<AudioFile?>((ref) => null);

class AudioNotifier extends AsyncNotifier<List<AudioFile>> {
  @override
  Future<List<AudioFile>> build() async {
    return ref.watch(fetchAudioFilesProvider).call();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future; // wait for the new build() to complete
  }
}

final audioProvider = AsyncNotifierProvider<AudioNotifier, List<AudioFile>>(
  AudioNotifier.new,
);
