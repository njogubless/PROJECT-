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
     
      FileType fileType = FileType.any;
      List<String>? allowedExtensions;
      
      if (storagePath == 'audio') {
        fileType = FileType.audio;
      } else if (storagePath == 'books') {
        fileType = FileType.custom;
       
        allowedExtensions = ['pdf', 'doc', 'docx', 'epub'];
      }
      
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
      );
       
      if (result == null) return;

      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;
      
     
      Reference fileRef = FirebaseStorage.instance.ref()
          .child(storagePath)
          .child(fileName);
      
     
      debugPrint('Attempting to upload to: $storagePath/$fileName');
     
      UploadTask uploadTask = fileRef.putFile(file);
      
     
      try {
     
        final TaskSnapshot taskSnapshot = await uploadTask;
       
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        
   
        await FirebaseFirestore.instance.collection(collectionPath).add({
          'fileName': fileName,
          'downloadUrl': downloadUrl,
          'fileType': storagePath, 
          'uploadedAt': FieldValue.serverTimestamp(),
          'fileSize': file.lengthSync(),
        });
        
        debugPrint('File uploaded successfully to $storagePath');
        
      } on FirebaseException catch (e) {
        debugPrint('Upload task error: ${e.code} - ${e.message}');
        rethrow;
      }
      
    } catch (e) {
      debugPrint('Error uploading file: $e');
     
      if (e is FirebaseException) {
        debugPrint('Firebase error code: ${e.code}');
        debugPrint('Firebase error message: ${e.message}');
      }
      rethrow;
    }
  }

 
  static Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

  static void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}