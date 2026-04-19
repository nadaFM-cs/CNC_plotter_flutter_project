import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constant/image_const.dart';
import '../model/custom_item.dart';

import 'sketch_state.dart';

class SketchCubit extends Cubit<SketchState> {
  SketchCubit()
      : super(SketchState(
          strokes: [],
          currentStroke: [],
          selectedColor: const Color(0xFFFDEFB4),
          strokeWidth: 5.0,
        ));

  double smoothingFactor = 0.2;
  final ImagePicker _picker = ImagePicker();

  

  void changeColor(Color color) => emit(state.copyWith(selectedColor: color));

  void changeStrokeWidth(double width) =>
      emit(state.copyWith(strokeWidth: width));

  void startStroke(Offset point) {
    emit(state.copyWith(currentStroke: [
      CustomItem(
        offset: point,
        paint: Paint()
          ..color = state.selectedColor
          ..strokeWidth = state.strokeWidth,
      )
    ]));
  }

  void updateStroke(Offset newPoint) {
    if (state.currentStroke.isEmpty) return;

    final lastPoint = state.currentStroke.last.offset;
    final smoothPoint = Offset(
      lastPoint.dx + (newPoint.dx - lastPoint.dx) * smoothingFactor,
      lastPoint.dy + (newPoint.dy - lastPoint.dy) * smoothingFactor,
    );

    emit(state.copyWith(
      currentStroke: List<CustomItem>.from(state.currentStroke)
        ..add(CustomItem(
          offset: smoothPoint,
          paint: Paint()
            ..color = state.selectedColor
            ..strokeWidth = state.strokeWidth
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round
            ..style = PaintingStyle.stroke,
        )),
    ));
  }

  void endStroke() {
    emit(state.copyWith(
      strokes: List<List<CustomItem>>.from(state.strokes)
        ..add(state.currentStroke),
      currentStroke: [],
    ));
  }

  void undo() {
    if (state.strokes.isEmpty) return;
    emit(state.copyWith(
      strokes: List<List<CustomItem>>.from(state.strokes)..removeLast(),
    ));
  }

  void clear() {
    emit(SketchState(
      strokes: [],
      currentStroke: [],
      selectedColor: state.selectedColor,
      strokeWidth: state.strokeWidth,
      backgroundImage: null,
    ));
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

 

  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      if (fromCamera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return;
      }
      final XFile? file = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (file != null) {
        emit(state.copyWith(backgroundImage: await file.readAsBytes()));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  

  Future<void> sendSketchToApi(Uint8List rawPngBytes) =>
      _sendToApi(rawPngBytes);


  Future<void> sendUploadedImageToApi(Uint8List originalBytes) =>
      _sendToApi(originalBytes);


  Future<void> sendPromptImageToApi(Uint8List originalBytes) =>
      _sendToApi(originalBytes);


  Future<void> _sendToApi(Uint8List rawBytes) async {
    emit(state.copyWith(
      isSending: true,
      isSentSuccess: false,
      clearError: true,
    ));

    try {
      
      final a4Bytes = await resizeToA4Png(rawBytes);

     
      await Future.delayed(const Duration(seconds: 2)); // Simulate

      emit(state.copyWith(isSending: false, isSentSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'Failed to send: $e',
      ));
    }
  }
}