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
  static Future<void> uploadFileToFirebase(String collectionPath, String storagePath) async {
    try {
      // Pick file using file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // Upload file to Firebase Storage
      Reference ref = FirebaseStorage.instance.ref('$storagePath/$fileName');
      UploadTask uploadTask = ref.putFile(file);

      await uploadTask.whenComplete(() => {});
      String downloadUrl = await ref.getDownloadURL();

      // Save file metadata in Firestore
      await FirebaseFirestore.instance.collection(collectionPath).add({
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      print('File uploaded successfully to $storagePath');
    } catch (e) {
      print('Error uploading file: $e');
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
