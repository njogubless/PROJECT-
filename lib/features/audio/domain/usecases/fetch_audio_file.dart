// domain/usecases/fetch_audio_files.dart

import 'package:devotion/features/audio/domain/entities/audio_file.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';


class FetchAudioFiles {
  final AudioRepository repository;

  FetchAudioFiles(this.repository);

  Future<List<AudioFile>> call() async {
    return await repository.fetchAudioFiles();
  }
}