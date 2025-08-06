import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class FileUploadService {
  Future<String?> uploadFile({
    required File file,
    required String folderName,
    required Function(double progress) onProgress,
  }) async {
        try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(file.path)}';
      final storageRef =
          FirebaseStorage.instance.ref().child('Audios').child(fileName);

      final uploadTask = storageRef.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      final TaskSnapshot snapshot = await uploadTask;

      final String downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('File uploaded successfully! Download URL: $downloadUrl');
      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint("Firebase Storage upload error: ${e.code} - ${e.message}");

      onProgress(-1.0);
      return null;
    } catch (e) {
      debugPrint("General upload error: $e");
      onProgress(-1.0);
      return null;
    }
  }
}
