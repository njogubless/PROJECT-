import 'package:devotion/features/audio/data/models/audio_model.dart';
import 'package:flutter/material.dart';


class AudioWidget extends StatelessWidget {
  final AudioFile audio;
  const AudioWidget({required this.audio});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Audio Cover Image (placeholder or fetched from network)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
               audio.coverUrl, // Replace with actual audio cover URL
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Audio Title and Duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${audio.duration.toString()} mins', // Display the duration of the audio
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Play Button
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                size: 40,
                color: Colors.teal,
              ),
              onPressed: () {
                // Trigger audio playback
                _playAudio(audio);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _playAudio(AudioFile audio) {
    // Handle audio playback functionality here
    debugPrint('Playing audio: ${audio.title}');
  }
}
