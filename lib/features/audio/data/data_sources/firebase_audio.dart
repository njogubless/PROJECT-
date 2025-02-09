// lib/features/audio/data/datasources/firebase_audio_data_source.dart

import 'dart:io';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseAudioDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseAudioDataSource(this.firestore, this.storage);

  Future<void> uploadAudioFile(AudioFile audioFile, String filePath) async {
    final ref = storage.ref().child('audio_files/${audioFile.id}.mp3');
    await ref.putFile(File(filePath));

    final downloadUrl = await ref.getDownloadURL();

    await firestore.collection('audio_files').doc(audioFile.id).set({
      'title': audioFile.title,
      'url': downloadUrl,
      'uploaderId': audioFile.uploaderId,
      'uploadDate': audioFile.uploadDate.toIso8601String(),
    });
  }

  Future<List<AudioFile>> fetchAudioFiles() async {
    final querySnapshot = await firestore.collection('audio_files').get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return AudioFile(
        id: doc.id,
        title: data['title'],
        url: data['url'],
        uploaderId: data['uploaderId'],
        uploadDate: DateTime.parse(data['uploadDate']),
        coverUrl: data['coverUrl'],
        duration: data ['duration'],
        setUrl: data['setUrl'],
        scripture: data['scripture'],
      );
    }).toList();
  }

  Future<AudioFile> getAudioFileById(String audioId) async {
    final doc = await firestore.collection('audio_files').doc(audioId).get();
    final data = doc.data()!;
    return AudioFile(
      id: doc.id,
      title: data['title'],
      url: data['url'],
      uploaderId: data['uploaderId'],
      uploadDate: DateTime.parse(data['uploadDate']),
      coverUrl:data['coverUrl'],
      duration: data['duration'], 
      setUrl: data['setUrl'],
      scripture: data['scripture'],
    );
  }

  Future<void> deleteAudioFile(String audioId) async {
    await firestore.collection('audio_files').doc(audioId).delete();
    await storage.ref().child('audio_files/$audioId.mp3').delete();
  }
}
