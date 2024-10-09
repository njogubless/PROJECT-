// lib/features/audio/presentation/providers/fetch_audio_files_provider.dart

import 'package:devotion/features/audio/domain/usecases/fetch_audio_file.dart';
import 'package:devotion/features/audio/presentation/providers/audio_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// The provider for the FetchAudioFiles use case
final fetchAudioFilesProvider = Provider<FetchAudioFiles>((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider);  // Retrieve the repository
  return FetchAudioFiles(audioRepository);  // Return an instance of FetchAudioFiles
});
