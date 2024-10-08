// lib/features/audio/data/repositories/firebase_audio_repository.dart

import 'dart:io';
import 'package:devotion/features/audio/data/data_sources/firebase_audio.dart';
import 'package:devotion/features/audio/domain/entities/audio_file.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class FirebaseAudioRepository implements AudioRepository {
  final FirebaseAudioDataSource dataSource;

  FirebaseAudioRepository(this.dataSource);

  @override
  Future<void> uploadAudioFile(AudioFile audioFile, String filePath) async {
    await dataSource.uploadAudioFile(audioFile, filePath);
  }

  @override
  Future<List<AudioFile>> fetchAudioFiles() async {
    return await dataSource.fetchAudioFiles();
  }

  @override
  Future<void> deleteAudioFile(String audioId) async {
    await dataSource.deleteAudioFile(audioId);
  }

  @override
  Future<String> downloadAudio(String audioId) async {
    final audioFile = await dataSource.getAudioFileById(audioId);
    final dio = Dio();

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/audio_files/$audioId.mp3';

    // Ensure the directory exists
    final file = File(filePath);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }

    await dio.download(audioFile.url, filePath);

    return filePath;
  }
}
