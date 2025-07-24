import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:devotion/features/audio/domain/repository/audio_repository.dart';
import 'package:flutter/material.dart';

class AudioRepositoryImpl implements AudioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> uploadAudioFile(AudioFile audioFile, String filePath) async {
    try {
      final ref = _storage.ref().child('audios/${audioFile.id}.mp3');
      final uploadTask = await ref.putFile(File(filePath));

      final downloadUrl = await uploadTask.ref.getDownloadURL();

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
      final firestoreSnapshot = await _firestore.collection('audioFiles').get();

      debugPrint(
          " fetching audio file successfully ---------------- ${firestoreSnapshot.docs.length}");

      if (firestoreSnapshot.docs.isNotEmpty) {
        return firestoreSnapshot.docs.map((doc) {
          final data = doc.data();
          debugPrint("Audio data ------------------: $data");
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
            duration: data['duration'] ?? Duration.zero,
            scripture: data['scripture'] ?? '',
          );
        }).toList();
      } else {
        final storageRef = _storage.ref().child('audios');
        final listResult = await storageRef.listAll();

        List<AudioFile> audioFiles = [];
        for (var item in listResult.items) {
          final url = await item.getDownloadURL();

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
      debugPrint('Error fetching audio files: $e');
      throw Exception('Failed to fetch audio files: $e');
    }
  }

  @override
  Future<void> deleteAudioFile(String audioId) async {
    try {
      final ref = _storage.ref().child('audios/$audioId.mp3');
      await ref.delete();

      await _firestore.collection('audioFiles').doc(audioId).delete();
    } catch (e) {
      throw Exception('Failed to delete audio file: $e');
    }
  }

  @override
  Future<String> downloadAudio(String audioId) async {
    try {
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
