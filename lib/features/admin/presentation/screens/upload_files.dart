import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devotion/core/constants/firebase_constants.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UploadFiles {
  /// Uploads a file to Firebase Storage and saves metadata to Firestore.
  // static Future<void> uploadFileToFirebase(String collectionPath, String storagePath) async {
  //   try {
  //     // Pick file using file picker
  //     FilePickerResult? result = await FilePicker.platform.pickFiles();
  //     if (result == null) return;

  //     File file = File(result.files.single.path!);
  //     String fileName = result.files.single.name;

  //     // Upload file to Firebase Storage
  //     Reference ref = FirebaseStorage.instance.ref('$storagePath/$fileName');
  //     UploadTask uploadTask = ref.putFile(file);

  //     await uploadTask.whenComplete(() => {});
  //     String downloadUrl = await ref.getDownloadURL();

  //     // Save file metadata in Firestore
  //     await FirebaseFirestore.instance.collection(collectionPath).add({
  //       'fileName': fileName,
  //       'downloadUrl': downloadUrl,
  //       'uploadedAt': FieldValue.serverTimestamp(),
  //     });

  //     print('File uploaded successfully to $storagePath');
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //     rethrow;
  //   }
  // }

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
    Reference fileRef = storageRef.child('$storagePath/$fileName');
    
    // Debug information
    print('Attempting to upload to: $storagePath/$fileName');
    
    // Start the upload task
    UploadTask uploadTask = fileRef.putFile(file);
    
    // Monitor upload progress
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
    }, onError: (e) {
      print('Upload task error: $e');
    });
    
    // Wait for upload to complete
    await uploadTask.whenComplete(() => print('Upload completed'));
    
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
    
    print('File uploaded successfully to $storagePath');
  } catch (e) {
    print('Error uploading file: $e');
    // More detailed error information
    if (e is FirebaseException) {
      print('Firebase error code: ${e.code}');
      print('Firebase error message: ${e.message}');
      
      if (e.code == 'object-not-found') {
        print('The storage path does not exist. You may need to create it first in Firebase Console.');
      } else if (e.code == 'unauthorized') {
        print('Check your Firebase Storage rules to ensure write access is allowed.');
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
