


import 'package:devotion/features/audio/domain/repository/audio_repository.dart';

class DownloadAudioFile {
  final AudioRepository repository;

  DownloadAudioFile(this.repository);

  Future<String> call(String audioId) async {
    return await repository.downloadAudio(audioId);
  }
}
