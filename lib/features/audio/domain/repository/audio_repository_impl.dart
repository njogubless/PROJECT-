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
      final ref = _storage.ref().child('audio/${audioFile.id}.mp3');
      final uploadTask = await ref.putFile(File(filePath));

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      await _firestore.collection('Sermons').doc(audioFile.id).set({
        'id': audioFile.id,
        'title': audioFile.title,
        'url': downloadUrl,
        'fileName': audioFile.title,
        'fileType': 'audio',
        'downloadUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to upload audio file: $e');
    }
  }

  @override
  Future<List<AudioFile>> fetchAudioFiles() async {
    try {
      final sermonsSnapshot = await _firestore.collection('Sermons').get();

      debugPrint(
          "Fetching from Sermons collection - ${sermonsSnapshot.docs.length} documents found");

      if (sermonsSnapshot.docs.isNotEmpty) {
        return sermonsSnapshot.docs.map((doc) {
          final data = doc.data();
          debugPrint("Sermon data: $data");

          String audioFileName = data['id'] ?? doc.id;
          if (data['downloadUrl'] != null) {
            final uri = Uri.parse(data['downloadUrl']);
            final pathSegments = uri.pathSegments;
            if (pathSegments.isNotEmpty) {
              audioFileName = pathSegments.last;

              audioFileName = audioFileName.split('?')[0];
            }
          }

          return AudioFile(
            id: audioFileName,
            title: data['fileName'] ?? data['title'] ?? 'Untitled Audio',
            url: data['downloadUrl'] ?? data['url'] ?? '',
            uploaderId: data['uploaderId'] ?? '',
            uploadDate: data['uploadedAt'] != null
                ? (data['uploadedAt'] as Timestamp).toDate()
                : DateTime.now(),
            coverUrl: data['coverUrl'] ?? '',
            setUrl: data['setUrl'] ?? '',
            duration: data['duration'] ?? Duration.zero,
            scripture: data['scripture'] ?? '',
          );
        }).toList();
      }

      final audioFilesSnapshot =
          await _firestore.collection('audioFiles').get();

      debugPrint(
          "Fetching from audioFiles collection - ${audioFilesSnapshot.docs.length} documents found");

      if (audioFilesSnapshot.docs.isNotEmpty) {
        return audioFilesSnapshot.docs.map((doc) {
          final data = doc.data();
          debugPrint("AudioFile data: $data");
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
      }

      debugPrint("Fetching directly from Storage");
      final storageRef = _storage.ref().child('audio');
      final listResult = await storageRef.listAll();

      List<AudioFile> audioFiles = [];
      for (var item in listResult.items) {
        try {
          final url = await item.getDownloadURL();
          final fileName = item.name;
          final title = fileName.replaceAll('.mp3', '').replaceAll('_', ' ');

          final metadata = await item.getMetadata();

          audioFiles.add(AudioFile(
            id: item.name,
            title: title,
            url: url,
            uploaderId: '',
            uploadDate: metadata.timeCreated ?? DateTime.now(),
            coverUrl: '',
            setUrl: '',
            duration: Duration.zero,
            scripture: '',
          ));
        } catch (e) {
          debugPrint('Error processing item ${item.name}: $e');
        }
      }

      return audioFiles;
    } catch (e) {
      debugPrint('Error fetching audio files: $e');
      throw Exception('Failed to fetch audio files: $e');
    }
  }

  @override
  Future<void> deleteAudioFile(String audioId) async {
    try {
      final ref = _storage.ref().child('audio/$audioId');
      await ref.delete();

      await _firestore.collection('Sermons').doc(audioId).delete();
      await _firestore.collection('audioFiles').doc(audioId).delete();
    } catch (e) {
      throw Exception('Failed to delete audio file: $e');
    }
  }

  @override
  Future<String> downloadAudio(String audioId) async {
    try {
      var doc = await _firestore.collection('Sermons').doc(audioId).get();
      var data = doc.data();

      if (data != null && data['downloadUrl'] != null) {
        return data['downloadUrl'];
      }

      doc = await _firestore.collection('audioFiles').doc(audioId).get();
      data = doc.data();

      if (data != null && data['url'] != null) {
        return data['url'];
      }

      throw Exception('Audio file not found');
    } catch (e) {
      throw Exception('Failed to download audio file: $e');
    }
  }
}
