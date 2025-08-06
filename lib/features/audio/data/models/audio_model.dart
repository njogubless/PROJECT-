import 'package:cloud_firestore/cloud_firestore.dart';

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
      'uploadDate': Timestamp.fromDate(uploadDate),
      'scripture': scripture,  
      
    };
  }

factory AudioFile.fromJson(Map<String, dynamic> json) {
  final timestamp = json['uploadedAt'];

  return AudioFile(
    id: json['id'] as String,
    title: json['title'] as String,
    url: json['url'] as String,
    coverUrl: json['coverUrl'] as String? ?? '',
    duration: Duration(seconds: json['duration'] as int? ?? 0),
    setUrl: json['setUrl'] as String? ?? '',
    uploaderId: json['uploaderId'] as String? ?? '',
    uploadDate: timestamp is Timestamp
        ? timestamp.toDate()
        : DateTime.tryParse(timestamp.toString()) ?? DateTime.now(),
    scripture: json['scripture'] as String? ?? '',
  );
}

}