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
      
      // Create storage reference directly to the file
      Reference fileRef = FirebaseStorage.instance.ref()
          .child(storagePath)
          .child(fileName);
      
      // Debug information
      debugPrint('Attempting to upload to: $storagePath/$fileName');
      
      // Start the upload task
      UploadTask uploadTask = fileRef.putFile(file);
      
      // Convert the task to a Future to handle errors better
      try {
        // Wait for upload to complete
        final TaskSnapshot taskSnapshot = await uploadTask;
        
        // Get download URL
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        
        // Add metadata to Firestore
        await FirebaseFirestore.instance.collection(collectionPath).add({
          'fileName': fileName,
          'downloadUrl': downloadUrl,
          'fileType': storagePath, // Store file type for easier filtering
          'uploadedAt': FieldValue.serverTimestamp(),
          'fileSize': file.lengthSync(), // Store file size in bytes
        });
        
        debugPrint('File uploaded successfully to $storagePath');
        
      } on FirebaseException catch (e) {
        debugPrint('Upload task error: ${e.code} - ${e.message}');
        rethrow;
      }
      
    } catch (e) {
      debugPrint('Error uploading file: $e');
      // More detailed error information
      if (e is FirebaseException) {
        debugPrint('Firebase error code: ${e.code}');
        debugPrint('Firebase error message: ${e.message}');
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