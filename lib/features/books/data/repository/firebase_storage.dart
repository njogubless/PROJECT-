import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<String> getDownloadURL(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      throw 'Failed to get download URL: $e';
    }
  }

  Future<File> downloadFile(String path, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        return file;
      }

      await _storage.ref(path).writeToFile(file);
      return file;
    } catch (e) {
      throw 'Failed to download file: $e';
    }
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  final storage = ref.watch(firebaseStorageProvider);
  return StorageService(storage);
});
