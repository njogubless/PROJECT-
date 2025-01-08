class Audio {
  final String id;                 // Unique identifier for the audio file
  final String title;              // Title of the audio
  final String audioUrl;           // URL for the audio file itself
  final String coverUrl;           // URL for the cover image of the audio
  final Duration duration;         // Duration of the audio in seconds/minutes
  final String setUrl;             // URL for the audio set if applicable
  final bool isPlaying;            // Boolean to indicate if the audio is playing
  final String uploaderId;         // ID of the user who uploaded the audio
  final DateTime uploadDate;       // Date when the audio was uploaded

  const Audio({
    required this.id,
    required this.title,
    required this.audioUrl,
    required this.coverUrl,
    required this.duration,
    required this.setUrl,
    this.isPlaying = false,        // Defaults to not playing
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
