import 'dart:typed_data';
import 'dart:ui';

import '../model/custom_item.dart';
const _absent = Object();
class SketchState {
  final List<List<CustomItem>> strokes;
  final List<CustomItem> currentStroke;
  final Color selectedColor;
  final double strokeWidth;
  final Uint8List? backgroundImage;  

  SketchState({
    required this.strokes,
    required this.currentStroke,
    required this.selectedColor,
    required this.strokeWidth,
    this.backgroundImage,
  });
SketchState copyWith({
  List<List<CustomItem>>? strokes,
  List<CustomItem>? currentStroke,
  Color? selectedColor,
  double? strokeWidth,
  Object? backgroundImage = _absent, 
}) {
  return SketchState(
    strokes: strokes ?? this.strokes,
    currentStroke: currentStroke ?? this.currentStroke,
    selectedColor: selectedColor ?? this.selectedColor,
    strokeWidth: strokeWidth ?? this.strokeWidth,
    backgroundImage: backgroundImage == _absent
        ? this.backgroundImage
        : backgroundImage as Uint8List?, 
  );
}
  }
