// First, add this to your pubspec.yaml dependencies:
// firebase_storage: ^11.2.5

// Create a storage service:
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Firebase Storage provider
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

// Storage service
class StorageService {
  final FirebaseStorage _storage;
  
  StorageService(this._storage);
  
  // Get download URL for a file
  Future<String> getDownloadURL(String path) async {
    try {
      return await _storage.ref(path).getDownloadURL();
    } catch (e) {
      throw 'Failed to get download URL: $e';
    }
  }
  
  // Download a file from Storage to local device
  Future<File> downloadFile(String path, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      
      // Check if file already exists
      if (await file.exists()) {
        return file;
      }
      
      // Download file
      await _storage.ref(path).writeToFile(file);
      return file;
    } catch (e) {
      throw 'Failed to download file: $e';
    }
  }
}

// Storage service provider
final storageServiceProvider = Provider<StorageService>((ref) {
  final storage = ref.watch(firebaseStorageProvider);
  return StorageService(storage);
});