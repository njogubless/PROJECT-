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
  final String scripture;        // Scripture for audio


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
    required this.scripture,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'coverUrl': coverUrl,
      'duration': duration.inSeconds,  // Convert Duration to seconds
      'setUrl': setUrl,
      'isPlaying': isPlaying,
      'uploaderId': uploaderId,
      'uploadDate': uploadDate.toIso8601String(),
      'scripture': scripture,  // Convert DateTime to ISO string
      
    };
  }

  factory AudioFile.fromJson(Map<String, dynamic> json) {
    return AudioFile(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      coverUrl: json['coverUrl'] as String,
      duration: Duration(seconds: json['duration'] as int),
      setUrl: json['setUrl'] as String,
      uploaderId: json['uploaderId'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
      scripture: json['scripture'] as String,
    );
  }
}