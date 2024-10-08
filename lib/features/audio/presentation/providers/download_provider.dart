// lib/features/audio/presentation/providers/download_provider.dart

import 'package:devotion/features/audio/domain/usecases/download_audio_file.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


enum DownloadStatus { initial, downloading, success, failure }

class DownloadState {
  final DownloadStatus status;
  final String? filePath;
  final String? error;

  DownloadState({required this.status, this.filePath, this.error});

  DownloadState copyWith({
    DownloadStatus? status,
    String? filePath,
    String? error,
  }) {
    return DownloadState(
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
    );
  }
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  final DownloadAudioFile downloadAudioFile;

  DownloadNotifier(this.downloadAudioFile)
      : super(DownloadState(status: DownloadStatus.initial));

  Future<void> download(String audioId) async {
    state = state.copyWith(status: DownloadStatus.downloading);
    try {
      final path = await downloadAudioFile(audioId);
      state = state.copyWith(status: DownloadStatus.success, filePath: path);
    } catch (e) {
      state = state.copyWith(status: DownloadStatus.failure, error: e.toString());
    }
  }
}

final downloadProvider = StateNotifierProvider.family<DownloadNotifier, DownloadState, String>((ref, audioId) {
  final downloadAudioFile = ref.read(downloadAudioFileProvider);
  return DownloadNotifier(downloadAudioFile);
});

// Use case provider
final downloadAudioFileProvider = Provider<DownloadAudioFile>((ref) {
  return DownloadAudioFile(ref.watch(audioRepositoryProvider));
});
