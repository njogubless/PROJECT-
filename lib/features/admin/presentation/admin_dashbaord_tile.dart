import 'dart:io';
import 'package:devotion/features/admin/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';

final uploadProgressProvider = StateProvider<double>((ref) => 0.0);

class DashboardTile extends ConsumerWidget {
  final String title;
  final String iconPath;
  final String route;
  final bool isPending;

  const DashboardTile({
    super.key,
    required this.title,
    required this.iconPath,
    required this.route,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(uploadProgressProvider);

    return GestureDetector(
      onTap: () async {
        if (route.contains('/upload')) {
          await _startFileUpload(context, ref);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(iconPath, height: 50, fit: BoxFit.cover),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            if (progress > 0 && progress < 1)
              CircularProgressIndicator(value: progress),
            if (progress == 1)
              const Icon(Icons.check_circle, size: 40, color: Colors.green),
            if (isPending)
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child:
                      const Icon(Icons.warning, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _startFileUpload(BuildContext context, WidgetRef ref) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final uploadService = FileUploadService();
    final notifier = ref.read(uploadProgressProvider.notifier);

    notifier.state = 0.0;

    FilePickerResult? result;
    String folderName = '';
    FileType fileType = FileType.any;

    if (title == "Upload Audio") {
      fileType = FileType.audio;
      folderName = 'Audios';
    } else if (title == "Upload Book") {
      fileType = FileType.custom;
      folderName = 'Books';

      result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'epub'],
      );
    } else {
      fileType = FileType.any;
      folderName = 'Others';
    }

    result ??= await FilePicker.platform.pickFiles(type: fileType);

    if (result == null || result.files.single.path == null) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('No file selected or picker canceled.')),
      );
      notifier.state = 0.0;
      return;
    }

    File selectedFile = File(result.files.single.path!);

    final downloadUrl = await uploadService.uploadFile(
      file: selectedFile,
      folderName: folderName,
      onProgress: (progress) {
        notifier.state = progress;
      },
    );

    if (downloadUrl != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
              'File uploaded successfully! URL: ${downloadUrl.substring(0, 50)}...'),
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text(
              'File upload failed! Please check console for errors and Firebase Storage rules.'),
          duration: Duration(seconds: 7),
        ),
      );
    }
  }
}
