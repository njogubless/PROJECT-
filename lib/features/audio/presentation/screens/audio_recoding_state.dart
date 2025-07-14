
enum AudioPlayerState { idle, playing, paused, stopped }

class AudioRecordingState {
  final bool isRecording;
  final bool isPaused;
  final String? recordedFilePath;
  final Duration recordingDuration;
  final List<double> waveformData;

  AudioRecordingState({
    this.isRecording = false,
    this.isPaused = false,
    this.recordedFilePath,
    this.recordingDuration = Duration.zero,
    this.waveformData = const [],
  });

  AudioRecordingState copyWith({
    bool? isRecording,
    bool? isPaused,
    String? recordedFilePath,
    Duration? recordingDuration,
    List<double>? waveformData,
  }) {
    return AudioRecordingState(
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      recordedFilePath: recordedFilePath ?? this.recordedFilePath,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      waveformData: waveformData ?? this.waveformData,
    );
  }
}



