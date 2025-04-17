import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';

class AudioRepositoryImpl implements AudioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> uploadAudioFile(AudioFile audioFile, String filePath) async {
    try {
      // Upload audio to Firebase Storage
      final ref = _storage.ref().child('audios/${audioFile.id}.mp3');
      final uploadTask = await ref.putFile(File(filePath));

      // Get the download URL of the uploaded file
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Save the audio metadata to Firestore
      await _firestore.collection('audioFiles').doc(audioFile.id).set({
        'id': audioFile.id,
        'title': audioFile.title,
        'url': downloadUrl,
      });
    } catch (e) {
      throw Exception('Failed to upload audio file: $e');
    }
  }

@override
Future<List<AudioFile>> fetchAudioFiles() async {
    try {
      // Try fetching from Firestore first
      final firestoreSnapshot = await _firestore.collection('audioFiles').get();
      
      // If we have documents in Firestore, use them
      if (firestoreSnapshot.docs.isNotEmpty) {
        return firestoreSnapshot.docs.map((doc) {
          final data = doc.data();
          return AudioFile(
            id: data['id'] ?? doc.id,
            title: data['title'] ?? 'Untitled Audio',
            url: data['url'] ?? '',
            uploaderId: data['uploaderId'] ?? '',
            uploadDate: data['uploadDate'] != null 
                ? (data['uploadDate'] as Timestamp).toDate() 
                : DateTime.now(),
            coverUrl: data['coverUrl'] ?? '',
            setUrl: data['setUrl'] ?? '',
            duration: data['duration'] ?? 0,
            scripture: data['scripture'] ?? '',
          );
        }).toList();
      } 
      // If no Firestore documents, try to list files directly from Storage
      else {
        // Reference to your audios folder in Storage
        final storageRef = _storage.ref().child('audios');
        final listResult = await storageRef.listAll();
        
        // Create AudioFile objects from the storage items
        List<AudioFile> audioFiles = [];
        for (var item in listResult.items) {
          // Get the download URL
          final url = await item.getDownloadURL();
          
          // Extract a title from the file name
          final fileName = item.name;
          final title = fileName.replaceAll('.mp3', '').replaceAll('_', ' ');
          
          audioFiles.add(AudioFile(
            id: item.name,
            title: title,
            url: url,
            uploaderId: '',
            uploadDate: DateTime.now(),
            coverUrl: '',
            setUrl: '',
            duration: Duration.zero,
            scripture: '',
          ));
        }
        
        return audioFiles;
      }
    } catch (e) {
      print('Error fetching audio files: $e');
      throw Exception('Failed to fetch audio files: $e');
    }
  }

  @override
  Future<void> deleteAudioFile(String audioId) async {
    try {
      // Delete audio from Firebase Storage
      final ref = _storage.ref().child('audios/$audioId.mp3');
      await ref.delete();

      // Delete metadata from Firestore
      await _firestore.collection('audioFiles').doc(audioId).delete();
    } catch (e) {
      throw Exception('Failed to delete audio file: $e');
    }
  }

  @override
  Future<String> downloadAudio(String audioId) async {
    try {
      // Fetch the download URL from Firestore
      final doc = await _firestore.collection('audioFiles').doc(audioId).get();
      final data = doc.data();

      if (data != null && data['url'] != null) {
        return data['url'];
      } else {
        throw Exception('Audio file not found');
      }
    } catch (e) {
      throw Exception('Failed to download audio file: $e');
    }
  }
}
