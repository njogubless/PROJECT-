// lib/features/audio/presentation/pages/audio_list_page.dart
class AudioListPage extends ConsumerWidget {
  const AudioListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recorded Sermons'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecordAudioPage()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Devotion').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final recordings = snapshot.data?.docs ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: recordings.length,
            itemBuilder: (context, index) {
              final recording = AudioFile.fromJson(
                recordings[index].data() as Map<String, dynamic>
              );

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.audio_file),
                  ),
                  title: Text(recording.title),
                  subtitle: Text(recording.scripture ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      // Navigate to audio player page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AudioPlayerPage(audioFile: recording),
                        ),
                      );
                    },
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