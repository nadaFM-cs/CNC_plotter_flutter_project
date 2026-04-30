import 'dart:io';
import 'package:cnc_plotter/constant/app_config.dart';
import 'package:cnc_plotter/core/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/custom_item.dart';

import 'sketch_state.dart';


class SketchCubit extends Cubit<SketchState> {
  final ApiService api = ApiService(AppConfig.baseUrl);

  SketchCubit()
      : super(SketchState(
    strokes: [],
    currentStroke: [],
    selectedColor: const Color(0xFFFDEFB4),
    strokeWidth: 5.0,
    isSending: false,
  ));

  double smoothingFactor = 0.2;
  final ImagePicker _picker = ImagePicker();


  void changeColor(Color color) => emit(state.copyWith(selectedColor: color));

  void changeStrokeWidth(double width) {
    emit(state.copyWith(strokeWidth: width));
  }

  void startStroke(Offset point) {
    emit(state.copyWith(currentStroke: [
      CustomItem(
        offset: point,
        paint: Paint()
          ..color = state.selectedColor
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round,
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
            ..strokeWidth = 2
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
      strokes: List<List<CustomItem>>.from(state.strokes)
        ..removeLast(),
    ));
  }

  void clear() {
    emit(SketchState(
      strokes: [],
      currentStroke: [],
      selectedColor: state.selectedColor,
      strokeWidth: state.strokeWidth,
      backgroundFile: null,
    ));
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  void resetState() {
    emit(state.copyWith(
      isSending: false,
      isSentSuccess: false,
      clearError: true,
    ));
  }

  Future<void> pickImage({bool fromCamera = false}) async {
    try {
      if (fromCamera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) return;
      }
      final XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        emit(state.copyWith(backgroundFile: file));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }


  Future<void> sendSketchToApi(File file) =>
      _sendToApi(file);

  Future<void> sendUploadedImageToApi(File file) =>
      _sendToApi(file);

  Future<void> sendPromptImageToApi(File file) =>
      _sendToApi(file);

  Future<void> _sendToApi(File file) async {
    emit(state.copyWith(
      isSending: true,
      isSentSuccess: false,
      clearError: true,
    ));

    try {
      await api?.sendFinalImage(file);

      emit(state.copyWith(
        isSending: false,
        isSentSuccess: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        errorMessage: 'Failed to send: $e',
      ));
    }
  }
}