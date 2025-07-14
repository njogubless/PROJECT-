

import 'package:devotion/features/audio/domain/usecases/fetch_audio_file.dart';
import 'package:devotion/features/audio/presentation/providers/audio_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final fetchAudioFilesProvider = Provider<FetchAudioFiles>((ref) {
  final audioRepository = ref.watch(audioRepositoryProvider); 
  return FetchAudioFiles(audioRepository);  
});
