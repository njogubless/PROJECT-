class AudioFile {
  final String id;
  final String title;
  final String url;           
  final String coverUrl;      
  final Duration duration;       
  final String setUrl;           
  final bool isPlaying;          
  final String uploaderId;
  final DateTime uploadDate;
  final String scripture;        


  AudioFile({
    required this.id,
    required this.title,
    required this.url,
    required this.coverUrl,
    required this.duration,
    required this.setUrl,
    this.isPlaying = false,    
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
      'duration': duration.inSeconds,  
      'setUrl': setUrl,
      'isPlaying': isPlaying,
      'uploaderId': uploaderId,
      'uploadDate': uploadDate.toIso8601String(),
      'scripture': scripture,  
      
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