import 'package:cnc_plotter/cubit/prompt_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/services/api_service.dart';

class PromptCubit extends Cubit<PromptState> {
  final ApiService api;

  PromptCubit(this.api) : super(const PromptInitial());

  void goToEdits() {
    final file = state.imageFile;
    if (file != null) emit(PromptEditMode(file));
  }

  void goBackToImage() {
    final file = state.imageFile;
    if (file != null) emit(PromptImageReady(imageFile: file));
  }

  void goBackToPrompt() => emit(const PromptInitial());

  Future<void> sendPrompt(String prompt) async {
    emit(const PromptLoading());

    try {
      final file = await api.sendPrompt(prompt);
      emit(PromptImageReady(imageFile: file));
    } catch (e) {
      emit(PromptError('Failed: $e'));
    }
  }

  Future<void> sendEdits(String edits) async {
    final file = state.imageFile;
    if (file == null) return;

    emit(PromptLoading(imageFile: file));

    try {
      final updated = await api.sendEdits(file, edits);
      emit(PromptImageReady(imageFile: updated));
    } catch (e) {
      emit(PromptError('Edit failed: $e', imageFile: file));
    }
  }

  Future<void> sendFinalImageForGCode() async {
    final file = state.imageFile;
    if (file == null) return;

    emit(PromptLoading(imageFile: file));

    try {
      final time = await api.sendFinalImage(file);
      emit(PromptSentSuccess(estimatedTime: time));
    } catch (e) {
      emit(PromptError('Send failed: $e', imageFile: file));
    }
  }
}