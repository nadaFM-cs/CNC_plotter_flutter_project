import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/custom_item.dart';
import 'sketch_state.dart';
import 'package:flutter/painting.dart';   
class SketchCubit extends Cubit<SketchState> {
  SketchCubit()
      : super(SketchState(
          strokes: [],
          currentStroke: [],
          selectedColor: Color(0xFFFDEFB4),
          strokeWidth: 5.0,
        ));

  double smoothingFactor = 0.2; 
 final ImagePicker _picker = ImagePicker();

  void changeColor(Color color) {
    emit(state.copyWith(selectedColor: color));
  }

  void changeStrokeWidth(double width) {
    emit(state.copyWith(strokeWidth: width));
  }

  void startStroke(Offset point) {
    final stroke = [
      CustomItem(
        offset: point,
        paint: Paint()
          ..color = state.selectedColor
          ..strokeWidth = state.strokeWidth,
      )
    ];

    emit(state.copyWith(currentStroke: stroke));
  }

  void updateStroke(Offset newPoint) {
    if (state.currentStroke.isEmpty) return;

    final lastPoint = state.currentStroke.last.offset;

    final smoothPoint = Offset(
      lastPoint.dx + (newPoint.dx - lastPoint.dx) * smoothingFactor,
      lastPoint.dy + (newPoint.dy - lastPoint.dy) * smoothingFactor,
    );

    final updated = List<CustomItem>.from(state.currentStroke)
      ..add(CustomItem(
        offset: smoothPoint,
        paint: Paint()
          ..color = state.selectedColor
          ..strokeWidth = state.strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke,
      ));

    emit(state.copyWith(currentStroke: updated));
  }

  void endStroke() {
    final updatedStrokes = List<List<CustomItem>>.from(state.strokes)
      ..add(state.currentStroke);

    emit(state.copyWith(
      strokes: updatedStrokes,
      currentStroke: [],
    ));
  }

  void undo() {
    if (state.strokes.isEmpty) return;

    final updated = List<List<CustomItem>>.from(state.strokes)
      ..removeLast();

    emit(state.copyWith(strokes: updated));
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
      if (!status.isGranted) {
        print('Camera permission denied');
        return;
      }
    }

    final XFile? file = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
      maxHeight: 1200,
    );

    if (file != null) {
      final bytes = await file.readAsBytes();
      emit(state.copyWith(backgroundImage: bytes));
    }
  } catch (e) {
    print('Error picking image: $e');
  }
}
}


