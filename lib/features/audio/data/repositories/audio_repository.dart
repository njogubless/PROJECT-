// import 'dart:io';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';

// class AudioRepository {
//   final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
//   final FlutterSoundPlayer _player = FlutterSoundPlayer();
//   String? filePath;

//   Future<void> startRecording() async {
//     Directory tempDir = await getApplicationDocumentsDirectory();
//     filePath = "${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac";
    
//     await _recorder.openRecorder();
//     await _recorder.startRecorder(toFile: filePath);
//   }

//   Future<void> stopRecording() async {
//     await _recorder.stopRecorder();
//   }

//   Future<List<File>> getAllRecordings() async {
//     Directory dir = await getApplicationDocumentsDirectory();
//     return dir.listSync().whereType<File>().toList();
//   }

//   Future<void> playAudio(File file) async {
//     await _player.openPlayer();
//     await _player.startPlayer(fromURI: file.path);
//   }

//   Future<void> stopPlayback() async {
//     await _player.stopPlayer();
//   }
// }
