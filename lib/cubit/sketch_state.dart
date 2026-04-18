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
  final bool isSending;
  final bool isSentSuccess;
  final String? errorMessage;

  SketchState({
    required this.strokes,
    required this.currentStroke,
    required this.selectedColor,
    required this.strokeWidth,
    this.backgroundImage,
    this.isSending = false,
    this.isSentSuccess = false,
    this.errorMessage,
  });

  SketchState copyWith({
    List<List<CustomItem>>? strokes,
    List<CustomItem>? currentStroke,
    Color? selectedColor,
    double? strokeWidth,
    Object? backgroundImage = _absent,
    bool? isSending,
    bool? isSentSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SketchState(
      strokes: strokes ?? this.strokes,
      currentStroke: currentStroke ?? this.currentStroke,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      backgroundImage: backgroundImage == _absent
          ? this.backgroundImage
          : backgroundImage as Uint8List?,
      isSending: isSending ?? this.isSending,
      isSentSuccess: isSentSuccess ?? this.isSentSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}