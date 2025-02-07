// lib/features/audio/presentation/widgets/waveform_painter.dart
import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final Color color;

  WaveformPainter({
    required this.waveformData,
    this.color = Colors.purple,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    if (waveformData.isEmpty) return;

    final width = size.width / waveformData.length;
    final middle = size.height / 2;

    for (var i = 0; i < waveformData.length; i++) {
      final x = i * width;
      final amplitude = waveformData[i] * size.height / 2;
      
      canvas.drawLine(
        Offset(x, middle - amplitude),
        Offset(x, middle + amplitude),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) => true;
}