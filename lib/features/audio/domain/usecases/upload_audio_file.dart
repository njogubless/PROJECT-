// domain/usecases/upload_audio_file.dart

import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';


class UploadAudioFile {
  final AudioRepository repository;

  UploadAudioFile(this.repository);

  Future<void> call(AudioFile audioFile, String filePath) async {
    return await repository.uploadAudioFile(audioFile, filePath);
  }
}
