
import 'package:devotion/features/audio/presentation/screens/audio_recoding_state.dart';
import 'package:flutter/material.dart';
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
  StreamSubscription? _amplitudeSubscription;

  void _initializeRecorder() {
    _audioRecorder = AudioRecorder();
  }

  Future<String> _getRecordingPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  Future<void> startRecording() async {
    try {
  
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) return;


      final path = await _getRecordingPath();

   
      await _audioRecorder.start(
        RecordConfig(
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
      debugPrint('Error starting recording: $e');
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
    _amplitudeSubscription?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) async {
      try {
        final amplitude = await _audioRecorder.getAmplitude();

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
    _amplitudeSubscription?.cancel();
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
    _amplitudeSubscription?.cancel();
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
    _amplitudeSubscription?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }
}