// lib/features/audio/presentation/providers/audio_recorder_provider.dart
import 'package:devotion/features/audio/presentation/screens/audio_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

final audioRecorderProvider = StateNotifierProvider<AudioRecorderNotifier, AudioRecordingState>((ref) {
  return AudioRecorderNotifier();
});

class AudioRecorderNotifier extends StateNotifier<AudioRecordingState> {
  AudioRecorderNotifier() : super(AudioRecordingState()) {
    _initializeRecorder();
  }
  
  late final AudioRecorder _audioRecorder;
  Timer? _timer;
  Timer? _amplitudeTimer;

  void _initializeRecorder() {
    _audioRecorder = AudioRecorder();
  }

  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> startRecording() async {
    try {
      // Check and request permissions
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) return;

      // Get the path for saving the recording
      final path = await _getRecordingPath();

      // Start recording
      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );
      
      _startTimer();
      _startAmplitudeListener();
      state = state.copyWith(isRecording: true, isPaused: false);
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(
        recordingDuration: state.recordingDuration + const Duration(seconds: 1),
      );
    });
  }

  void _startAmplitudeListener() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      try {
        final amplitude = await _audioRecorder.getAmplitude();
        // Convert amplitude to waveform data (normalized between 0 and 1)
        final normalized = (amplitude.current + 160) / 160;
        state = state.copyWith(
          waveformData: [...state.waveformData, normalized],
        );
      } catch (e) {
        print('Error getting amplitude: $e');
      }
    });
  }

  Future<void> pauseRecording() async {
    await _audioRecorder.pause();
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    state = state.copyWith(isPaused: true);
  }

  Future<void> resumeRecording() async {
    await _audioRecorder.resume();
    _startTimer();
    _startAmplitudeListener();
    state = state.copyWith(isPaused: false);
  }

  Future<void> stopRecording() async {
    final path = await _audioRecorder.stop();
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    if (path != null) {
      state = state.copyWith(
        isRecording: false,
        isPaused: false,
        recordedFilePath: path,
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudeTimer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}