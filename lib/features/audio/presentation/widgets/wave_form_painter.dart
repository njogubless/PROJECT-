import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final Color color;

  WaveformPainter({
    required this.waveformData,
    this.color = const Color.fromARGB(255, 82, 169, 240),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / waveformData.length;
    final middle = size.height / 2;

    for (var i = 0; i < waveformData.length; i++) {
      final x =
          i * barWidth + barWidth / 2; // FIX: Centre each bar in its slot.

      final amplitude = waveformData[i].clamp(0.0, 1.0) * middle;

      canvas.drawLine(
        Offset(x, middle - amplitude),
        Offset(x, middle + amplitude),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.waveformData != waveformData ||
        oldDelegate.color != color;
  }
}
