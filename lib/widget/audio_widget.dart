import 'package:flutter/material.dart';


class AudioWidget extends StatelessWidget {
  final Audio audio;
  const AudioWidget({required this.audio});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Audio Cover Image (placeholder or fetched from network)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                audio.coverUrl ?? 'https://via.placeholder.com/100', // Replace with actual audio cover URL
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),

            // Audio Title and Duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audio.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${audio.duration.toString()} mins', // Display the duration of the audio
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Play Button
            IconButton(
              icon: Icon(
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

  void _playAudio(Audio audio) {
    // Handle audio playback functionality here
    print('Playing audio: ${audio.title}');
  }
}