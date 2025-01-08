
class AudioFile {
  final String id;
  final String title;
  final String url;             // URL for audio file itself
  final String coverUrl;         // URL for audio cover image
  final Duration duration;       // Duration of audio
  final String setUrl;           // URL for audio set, if available
  final bool isPlaying;          // Status to indicate if audio is playing
  final String uploaderId;
  final DateTime uploadDate;

  AudioFile({
    required this.id,
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.duration,
    required this.setUrl,
    this.isPlaying = false,      // Default value for audio play status
    required this.uploaderId,
    required this.uploadDate,
  });
}
