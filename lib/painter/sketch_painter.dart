import 'package:flutter/material.dart';

import '../model/custom_item.dart';


class SketchPainter extends CustomPainter {
  final List<List<CustomItem>> strokes;
  final List<CustomItem> currentStroke;

  SketchPainter({
    required this.strokes,
    required this.currentStroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          stroke[i].offset,
          stroke[i + 1].offset,
          stroke[i].paint,
        );
      }
    }

    for (int i = 0; i < currentStroke.length - 1; i++) {
      canvas.drawLine(
        currentStroke[i].offset,
        currentStroke[i + 1].offset,
        currentStroke[i].paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant SketchPainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke;
  }
}