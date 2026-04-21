// Removed: AudioPlayerState enum does not belong here — it conflicts with
// AudioPlayerState class defined in audio_player_provider.dart.
// If you need a simple playback enum elsewhere, define it in its own file.

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
    // FIX: Use Object? sentinel to allow explicitly clearing the path back to
    // null (e.g. after a reset), which plain `String?` copyWith cannot do.
    Object? recordedFilePath = _sentinel,
    Duration? recordingDuration,
    List<double>? waveformData,
  }) {
    return AudioRecordingState(
      isRecording: isRecording ?? this.isRecording,
      isPaused: isPaused ?? this.isPaused,
      recordedFilePath: recordedFilePath == _sentinel
          ? this.recordedFilePath
          : recordedFilePath as String?,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      waveformData: waveformData ?? this.waveformData,
    );
  }
}

// Private sentinel used by copyWith to distinguish "not provided" from null.
const Object _sentinel = Object();