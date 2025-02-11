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
      // Fetch the audio files metadata from Firestore
      final snapshot = await _firestore.collection('audioFiles').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return AudioFile(
          id: data['id'],
          title: data['title'],
          url: data['url'],
          uploaderId: data['id'],
          uploadDate: data['date'], 
          coverUrl: data['coverUrl'], 
          setUrl:data['setUrl'], 
          duration: data['duration'],
<<<<<<< HEAD
          scripture: data['scripture'],
          
=======
          scripture: data['scripture'],          
>>>>>>> d8dc86b ( making changes on the audio platform and book screen)
        );
      }).toList();
    } catch (e) {
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
