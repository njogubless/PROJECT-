import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class UploadFiles extends ConsumerWidget {
  const UploadFiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<File> saveFilePermanently(PlatformFile file) async {
      final appStorage = await getApplicationDocumentsDirectory();
      final newFile = File('${appStorage.path}/${file.name}');
      return File(file.path!).copy(newFile.path);
    }

    void openFile(PlatformFile file) {
      OpenFile.open(file.path!);
    }

    void openFiles(List<PlatformFile> files) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FilesPage(
              files: files,
              onOpenedFile: openFile,
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text('File Upload'),
      ),
      body: Container(
        constraints: const BoxConstraints(
          maxWidth: 400,
        ),
        padding: const EdgeInsets.all(32),
        alignment: Alignment.topCenter,
        child: ElevatedButton(
          onPressed: () async {
            final result =
                await FilePicker.platform.pickFiles(allowMultiple: true);
            if (result == null) return;

            openFiles(result.files);

            //open single file
            final file = result.files.first;
            openFile(file);

            debugPrint(' Name: ${file.name}');
            debugPrint(' Bytes: ${file.bytes}');
            debugPrint(' Size: ${file.size}');
            debugPrint(' Extension: ${file.extension}');
            debugPrint(' Path: ${file.path}');

            final newFile = await saveFilePermanently(file);
            debugPrint('from Path: ${file.path}');
            debugPrint('To Path: ${newFile.path}');
          },
          child: const Text('Upload Files'),
        ),
      ),
    );
  }
}

class FilesPage extends StatelessWidget {
  final List<PlatformFile> files;
  final void Function(PlatformFile) onOpenedFile;

  const FilesPage({
    super.key,
    required this.files,
    required this.onOpenedFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Files'),
      ),
      body: ListView.builder(
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return ListTile(
            title: Text(file.name),
            subtitle: Text('Size: ${file.size} bytes'),
            onTap: () => onOpenedFile(file),
          );
        },
      ),
    );
  }
}