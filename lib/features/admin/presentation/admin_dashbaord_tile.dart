import 'package:devotion/features/admin/file_upload_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final uploadProgressProvider = StateProvider<double>((ref) => 0.0);

class DashboardTile extends ConsumerWidget {
  final String title;
  final String iconPath;
  final String route;
  final bool isPending;

  const DashboardTile({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.route,
    this.isPending = false,
  }) : super(key: key);

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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                  child: const Icon(Icons.warning, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _startFileUpload(BuildContext context, WidgetRef ref) async {
    final uploadService = FileUploadService();
    final notifier = ref.read(uploadProgressProvider.notifier);

    // Reset progress to 0 before starting
    notifier.state = 0.0;

    // Simulate file upload and update progress
    await uploadService.uploadFile(
      filePath: 'path/to/file', // Replace with actual file selection
      onProgress: (progress) {
        notifier.state = progress;
      },
    );

    // Notify completion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File uploaded successfully!')),
    );
  }
}
