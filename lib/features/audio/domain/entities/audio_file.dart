// domain/entities/audio_file.dart

class AudioFile {
  final String id;
  final String title;
  final String url;
  final String uploaderId;
  final DateTime uploadDate;

  AudioFile({
    required this.id,
    required this.title,
    required this.url,
    required this.uploaderId,
    required this.uploadDate,
  });
}
