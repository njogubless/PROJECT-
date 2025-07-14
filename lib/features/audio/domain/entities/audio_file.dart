class Audio {
  final String id;               
  final String title;            
  final String audioUrl;          
  final String coverUrl;        
  final Duration duration;         
  final String setUrl;          
  final bool isPlaying;            
  final String uploaderId;        
  final DateTime uploadDate;      

  const Audio({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.coverUrl,
    required this.duration,
    required this.setUrl,
    this.isPlaying = false,       
    required this.uploaderId,
    required this.uploadDate,
  });

  List<Object?> get props => [
        id,
        title,
        audioUrl,
        coverUrl,
        duration,
        setUrl,
        isPlaying,
        uploaderId,
        uploadDate,
      ];
}
