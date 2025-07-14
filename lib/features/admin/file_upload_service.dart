import 'dart:async';

class FileUploadService {
 
  Future<void> uploadFile({
    required String filePath,
    required Function(double progress) onProgress,
  }) async {
    for (double progress = 0; progress <= 1; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 300));
      onProgress(progress);
    }
  }
}
