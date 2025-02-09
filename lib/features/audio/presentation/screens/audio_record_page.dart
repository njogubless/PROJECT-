// // lib/features/audio/presentation/pages/record_audio_page.dart
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:devotion/features/audio/data/models/audio_model.dart';
// import 'package:devotion/features/audio/presentation/providers/audio_provider.dart';
// import 'package:devotion/features/audio/presentation/widgets/wave_form_painter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class DevotionPage extends ConsumerStatefulWidget {
//   const DevotionPage({super.key});

//   @override
//   _RecordAudioPageState createState() => _RecordAudioPageState();
// }

// class _RecordAudioPageState extends ConsumerState<DevotionPage> {
//   final _titleController = TextEditingController();
//   final _scriptureController = TextEditingController();
//   final _ministerController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final recordingState = ref.watch(audioRecorderProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Record Sermon'),
//         actions: [
//           if (recordingState.recordedFilePath != null)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _submitRecording,
//             ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Form fields in a scrollable container
//             Expanded(
//               flex: 1,
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: _titleController,
//                         decoration: const InputDecoration(
//                           labelText: 'Sermon Title',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: _scriptureController,
//                         decoration: const InputDecoration(
//                           labelText: 'Scripture Reference',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: _ministerController,
//                         decoration: const InputDecoration(
//                           labelText: 'Minister Name',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // Recording controls and waveform
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     height: 120, // Fixed height for waveform
//                     child: CustomPaint(
//                       painter: WaveformPainter(
//                         waveformData: recordingState.waveformData,
//                       ),
//                       size: const Size(double.infinity, 120),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _formatDuration(recordingState.recordingDuration),
//                     style: Theme.of(context).textTheme.headlineSmall,
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (!recordingState.isRecording)
//                         FloatingActionButton(
//                           onPressed: () => ref
//                               .read(audioRecorderProvider.notifier)
//                               .startRecording(),
//                           child: const Icon(Icons.mic),
//                         )
//                       else ...[
//                         FloatingActionButton(
//                           onPressed: recordingState.isPaused
//                               ? () => ref
//                                   .read(audioRecorderProvider.notifier)
//                                   .resumeRecording()
//                               : () => ref
//                                   .read(audioRecorderProvider.notifier)
//                                   .pauseRecording(),
//                           child: Icon(recordingState.isPaused
//                               ? Icons.play_arrow
//                               : Icons.pause),
//                         ),
//                         const SizedBox(width: 20),
//                         FloatingActionButton(
//                           onPressed: () => ref
//                               .read(audioRecorderProvider.notifier)
//                               .stopRecording(),
//                           child: const Icon(Icons.stop),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   Future<void> _submitRecording() async {
//     final recordingState = ref.read(audioRecorderProvider);

//     if (recordingState.recordedFilePath == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No recording available')),
//       );
//       return;
//     }

//     try {
//       // Show loading indicator
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );

//       // 1. Upload audio file to Firebase Storage
//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('devotions')
//           .child('${DateTime.now().millisecondsSinceEpoch}.m4a');

//       final audioFile = File(recordingState.recordedFilePath!);
//       final uploadTask = await storageRef.putFile(audioFile);
//       final downloadUrl = await uploadTask.ref.getDownloadURL();

//       // 2. Create Firestore document
//       final devotionDoc = AudioFile(
//         id: DateTime.now().millisecondsSinceEpoch.toString(),
//         title: _titleController.text,
//         url: downloadUrl,
//         coverUrl: '', // Optional cover image
//         duration: recordingState.recordingDuration,
//         setUrl: '', // Optional set URL
//         uploaderId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
//         uploadDate: DateTime.now(),
//       );

//       // 3. Save to Firestore
//       await FirebaseFirestore.instance
//           .collection('Devotion')
//           .doc(devotionDoc.id)
//           .set(devotionDoc.toJson());

//       // Close loading dialog
//       Navigator.pop(context);

//       // Show success message
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Recording uploaded successfully')),
//       );

//       // Navigate back
//       Navigator.pop(context);
//     } catch (e) {
//       // Close loading dialog
//       Navigator.pop(context);

//       // Show error message
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading recording: $e')),
//       );
//     }
//   }
// }
// lib/features/audio/presentation/pages/record_audio_page.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:devotion/features/audio/presentation/providers/audio_provider.dart';
import 'package:devotion/features/audio/presentation/widgets/wave_form_painter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordAudioPage extends ConsumerStatefulWidget {
  const RecordAudioPage({super.key});

  @override
  _RecordAudioPageState createState() => _RecordAudioPageState();
}

class _RecordAudioPageState extends ConsumerState<RecordAudioPage> {

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _submitRecording() async {
    final recordingState = ref.read(audioRecorderProvider);

    if (recordingState.recordedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording available')),
      );
      return;
    }

    //validate form fields
    if(_titleController.text.isEmpty || _scriptureController.text.isEmpty || _ministerController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // 1. Upload audio file to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('Devotion')
          .child('${DateTime.now().millisecondsSinceEpoch}.m4a');

      final audioFile = File(recordingState.recordedFilePath!);
      final uploadTask = await storageRef.putFile(audioFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // 2. Create Firestore document
      final devotionDoc = AudioFile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        url: downloadUrl,
        coverUrl: '', // Optional cover image
        duration: recordingState.recordingDuration,
        setUrl: '', // Optional set URL
        uploaderId: FirebaseAuth.instance.currentUser?.uid ?? 'anonymous',
        uploadDate: DateTime.now(),
        scripture: _scriptureController.text,
      );

      // 3. Save to Firestore
      await FirebaseFirestore.instance
          .collection('Devotion')
          .doc(devotionDoc.id)
          .set(devotionDoc.toJson());

      // Close loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording uploaded successfully'),
        backgroundColor: Colors.green,),
      );

      // Navigate back
      Navigator.pop(context);
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading recording: $e'),
        backgroundColor: Colors.red,),
      );
    }
  }










  final _titleController = TextEditingController();
  final _scriptureController = TextEditingController();
  final _ministerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final recordingState = ref.watch(audioRecorderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Sermon'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Sermon Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _scriptureController,
                        decoration: InputDecoration(
                          labelText: 'Scripture Reference',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _ministerController,
                        decoration: InputDecoration(
                          labelText: 'Minister Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Recording section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatDuration(recordingState.recordingDuration),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 80,
                              child: CustomPaint(
                                painter: WaveformPainter(
                                  waveformData: recordingState.waveformData,
                                ),
                                size: const Size(double.infinity, 80),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!recordingState.isRecording)
                                  FloatingActionButton(
                                    onPressed: () => ref.read(audioRecorderProvider.notifier).startRecording(),
                                    backgroundColor: Colors.red,
                                    child: const Icon(Icons.mic),
                                  )
                                else ...[
                                  FloatingActionButton(
                                    onPressed: recordingState.isPaused
                                        ? () => ref.read(audioRecorderProvider.notifier).resumeRecording()
                                        : () => ref.read(audioRecorderProvider.notifier).pauseRecording(),
                                    backgroundColor: Colors.orange,
                                    child: Icon(recordingState.isPaused ? Icons.play_arrow : Icons.pause),
                                  ),
                                  const SizedBox(width: 20),
                                  FloatingActionButton(
                                    onPressed: () => ref.read(audioRecorderProvider.notifier).stopRecording(),
                                    backgroundColor: Colors.red,
                                    child: const Icon(Icons.stop),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (recordingState.recordedFilePath != null) ...[
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _submitRecording,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Submit Recording'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
