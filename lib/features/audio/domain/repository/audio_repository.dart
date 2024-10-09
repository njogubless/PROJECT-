// domain/repositories/audio_repository.dart

import 'package:devotion/features/audio/domain/entities/audio_file.dart';

abstract class AudioRepository {
  Future<void> uploadAudioFile(AudioFile audioFile, String filePath);
  Future<List<AudioFile>> fetchAudioFiles();
  Future<void> deleteAudioFile(String audioId);
  Future<String> downloadAudio(String audioId);
}


