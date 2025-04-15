import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UploadFiles {

 static Future<void> uploadFileToFirebase(String collectionPath, String storagePath) async {
  try {
    // Customize file picker options based on storage path
    FileType fileType = FileType.any;
    List<String>? allowedExtensions;
    
    if (storagePath == 'audio') {
      fileType = FileType.audio;
    } else if (storagePath == 'books') {
      fileType = FileType.custom;
      // Allow common document formats
      allowedExtensions = ['pdf', 'doc', 'docx', 'epub'];
    }
    
    // Pick file with appropriate constraints
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );
    
    if (result == null) return;

    File file = File(result.files.single.path!);
    String fileName = result.files.single.name;
    
    // Create storage reference - ensure this path exists
    Reference storageRef = FirebaseStorage.instance.ref();
    
    // Add this new code to ensure the directory exists
    try {
      // Try to list items in the directory to check if it exists
      await storageRef.child(storagePath).listAll();
      debugPrint('Storage path exists: $storagePath');
    } catch (e) {
      // If directory doesn't exist, create an empty placeholder file
      debugPrint('Creating directory structure: $storagePath');
      await storageRef.child('$storagePath/.placeholder').putString('');
    }
    
    // Now create reference to the actual file
    Reference fileRef = storageRef.child('$storagePath/$fileName');
    
    // Debug information
    debugPrint('Attempting to upload to: $storagePath/$fileName');
    
    // Start the upload task
    UploadTask uploadTask = fileRef.putFile(file);
    
    // Monitor upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      debugPrint('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
    }, onError: (e) {
      debugPrint('Upload task error: $e');
    });
    
    // Wait for upload to complete
    await uploadTask.whenComplete(() => debugPrint('Upload completed'));
    
    // Get download URL
    String downloadUrl = await fileRef.getDownloadURL();
    
    // Add metadata to Firestore
    await FirebaseFirestore.instance.collection(collectionPath).add({
      'fileName': fileName,
      'downloadUrl': downloadUrl,
      'fileType': storagePath, // Store file type for easier filtering
      'uploadedAt': FieldValue.serverTimestamp(),
      'fileSize': file.lengthSync(), // Store file size in bytes
    });
    
    debugPrint('File uploaded successfully to $storagePath');
  } catch (e) {
    debugPrint('Error uploading file: $e');
    // More detailed error information
    if (e is FirebaseException) {
      debugPrint('Firebase error code: ${e.code}');
      debugPrint('Firebase error message: ${e.message}');
      
      if (e.code == 'object-not-found') {
        debugPrint('The storage path does not exist. You may need to create it first in Firebase Console.');
      } else if (e.code == 'unauthorized') {
        debugPrint('Check your Firebase Storage rules to ensure write access is allowed.');
      }
    }
    rethrow;
  }
}

  // Save file permanently in local storage
  static Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  // Open file
  static void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
