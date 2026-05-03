import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import '../model/custom_item.dart';

const _absent = Object();

class SketchState {
  final List<List<CustomItem>> strokes;
  final List<CustomItem> currentStroke;
  final Color selectedColor;
  final double strokeWidth;
  final File? backgroundFile;
  final bool isSending;
  final bool isSentSuccess;
  final String? errorMessage;
  final String? estimatedTime;


  SketchState({
    required this.strokes,
    required this.currentStroke,
    required this.selectedColor,
    required this.strokeWidth,
    this.backgroundFile,
    this.isSending = false,
    this.isSentSuccess = false,
    this.errorMessage,
    this.estimatedTime,
  });

  SketchState copyWith({
    List<List<CustomItem>>? strokes,
    List<CustomItem>? currentStroke,
    Color? selectedColor,
    double? strokeWidth,
    Object? backgroundFile = _absent,
    bool? isSending,
    bool? isSentSuccess,
    String? errorMessage,
    bool clearError = false,
    String? estimatedTime,
  }) {
    return SketchState(
      strokes: strokes ?? this.strokes,
      currentStroke: currentStroke ?? this.currentStroke,
      selectedColor: selectedColor ?? this.selectedColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      backgroundFile: backgroundFile == _absent
          ? this.backgroundFile
          : backgroundFile as File?,
      isSending: isSending ?? this.isSending,
      isSentSuccess: isSentSuccess ?? this.isSentSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}