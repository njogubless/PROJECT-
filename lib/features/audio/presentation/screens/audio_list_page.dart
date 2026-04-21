import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/screens/audio_player_page.dart';
import 'package:devotion/features/audio/presentation/screens/audio_recording_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final _mergedAudioProvider = StreamProvider<List<AudioFile>>((ref) {
  final db = FirebaseFirestore.instance;
  final devotionStream = db
      .collection('Devotion')
      .where('approvalStatus', isEqualTo: 'approved')
      .snapshots();
  final sermonsStream = db.collection('Sermons').snapshots();
  return _combineSnapshots(devotionStream, sermonsStream).map((pair) {
    final allFiles = [
      ...pair.$1.docs.map(AudioFile.fromSnapshot),
      ...pair.$2.docs.map(AudioFile.fromSnapshot),
    ];
    allFiles.sort((a, b) => b.uploadDate.compareTo(a.uploadDate));
    return allFiles;
  });
});

Stream<(QuerySnapshot, QuerySnapshot)> _combineSnapshots(
  Stream<QuerySnapshot> streamA,
  Stream<QuerySnapshot> streamB,
) {
  final controller = StreamController<(QuerySnapshot, QuerySnapshot)>.broadcast();
  QuerySnapshot? latestA;
  QuerySnapshot? latestB;
  void tryEmit() {
    if (latestA != null && latestB != null) controller.add((latestA!, latestB!));
  }
  final subA = streamA.listen((snap) { latestA = snap; tryEmit(); }, onError: controller.addError);
  final subB = streamB.listen((snap) { latestB = snap; tryEmit(); }, onError: controller.addError);
  controller.onCancel = () { subA.cancel(); subB.cancel(); };
  return controller.stream;
}

class DevotionPage extends ConsumerWidget {
  const DevotionPage({super.key});

  static String _formatDuration(Duration? duration) {
    if (duration == null || duration == Duration.zero) return '';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioAsync = ref.watch(_mergedAudioProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sermons'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Record a sermon',
            onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const RecordAudioPage())),
          ),
        ],
      ),
      body: audioAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error loading sermons:\n$e',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[700])),
            ]),
          ),
        ),
        data: (files) {
          if (files.isEmpty) {
            return const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.mic_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No sermons available yet', style: TextStyle(color: Colors.grey)),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: files.length,
            itemBuilder: (context, index) {
              final file = files[index];
              final formattedDate = DateFormat('MMM d, yyyy').format(file.uploadDate);
              final durationLabel = _formatDuration(file.duration);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.15),
                    child: Icon(Icons.audio_file, color: Theme.of(context).primaryColor),
                  ),
                  title: Text(file.title),
                  subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (file.scripture.isNotEmpty) Text(file.scripture),
                    Text(
                      [formattedDate, if (durationLabel.isNotEmpty) durationLabel].join(' · '),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ]),
                  trailing: IconButton(
                    icon: Icon(Icons.play_arrow, color: Theme.of(context).primaryColor),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AudioPlayerPage(audioFile: file)),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}