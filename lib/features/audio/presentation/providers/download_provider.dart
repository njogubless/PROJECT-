import 'dart:io';
import 'package:devotion/features/audio/presentation/providers/audio_repository_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

enum DownloadStatus { initial, downloading, success, failure }

class DownloadState {
  final DownloadStatus status;
  final String? error;

  const DownloadState({required this.status, this.error});

  factory DownloadState.initial() => const DownloadState(status: DownloadStatus.initial);
  factory DownloadState.downloading() => const DownloadState(status: DownloadStatus.downloading);
  factory DownloadState.success() => const DownloadState(status: DownloadStatus.success);
  factory DownloadState.failure(String error) => DownloadState(status: DownloadStatus.failure, error: error);
}

class DownloadNotifier extends StateNotifier<DownloadState> {
  final String audioUrl;
  final String fileName;

  DownloadNotifier({required this.audioUrl, required this.fileName}) : super(DownloadState.initial());

  Future<void> download() async {
    state = DownloadState.downloading();

    try {
      final dir = await getApplicationDocumentsDirectory(); 
      final filePath = '${dir.path}/$fileName';

      final dio = Dio();
      final response = await dio.download(audioUrl, filePath);

      if (response.statusCode == 200) {
        state = DownloadState.success();
      } else {
        state = DownloadState.failure('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      state = DownloadState.failure(e.toString());
    }
  }
}

final downloadProvider = StateNotifierProvider.family<DownloadNotifier, DownloadState, String>(
  (ref, audioId) {
    final audioAsync = ref.watch(audioProvider);

    return audioAsync.maybeWhen(
      data: (audioList) {
        final audio = audioList.firstWhere((a) => a.id == audioId);
        return DownloadNotifier(audioUrl: audio.url, fileName: '${audio.title}.mp3');
      },
      orElse: () => DownloadNotifier(audioUrl: '', fileName: 'pending.mp3'),
    );
  },
);



