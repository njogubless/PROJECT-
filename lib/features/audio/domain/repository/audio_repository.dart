

import 'package:devotion/features/audio/data/models/audio_model.dart';

abstract class AudioRepository {
  Future<void> uploadAudioFile(AudioFile audioFile, String filePath);
  Future<List<AudioFile>> fetchAudioFiles();
  Future<void> deleteAudioFile(String audioId);
  Future<String> downloadAudio(String audioId);
  
}


