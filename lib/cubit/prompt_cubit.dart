
import 'package:cnc_plotter/cubit/prompt_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptCubit extends Cubit< PromptState> {

  PromptCubit() : super(const PromptInitial());
  void goToEdits() {
    final url = state.imageUrl;
    if (url != null) emit(PromptEditMode(url));
  }

  void goBackToImage() {
    final url = state.imageUrl;
    if (url != null) emit(PromptImageReady(imageUrl: url));
  }

  void goBackToPrompt() => emit(const PromptInitial());

  Future<void> sendPrompt(String prompt) async {
  emit(const PromptLoading());

  try {
    await Future.delayed(const Duration(seconds: 2));

  
    emit(PromptImageReady(
      imageUrl: null,
    ));

    await Future.delayed(const Duration(seconds: 2));

    emit(PromptImageReady(
      imageUrl: "https://example.com/image.png",
    ));

  } catch (e) {
    emit(PromptError('Failed: $e'));
  }
}

 Future<void> sendEdits(String edits) async {
  final currentUrl = state.imageUrl;

  try {
    await Future.delayed(const Duration(seconds: 2));

    // هنا المفروض API بيرجع صورة جديدة
    final updatedImageUrl = "https://example.com/updated.png";

    emit(PromptImageReady(
      imageUrl: updatedImageUrl,
    ));

  } catch (e) {
    emit(PromptError(
      'Failed to apply edits: $e',
      imageUrl: currentUrl,
    ));
  }
}
 Future<void> sendFinalImageForGCode() async {
  final url = state.imageUrl;
  if (url == null) return;

  try {
    emit(PromptLoading(imageUrl: url));

    //  هنا API الحقيقي
    await Future.delayed(const Duration(seconds: 2));

    // مثال:
    // await api.sendImageToAI(imageUrl: url);

    emit(PromptImageReady(imageUrl: url));

  
    emit(PromptSentSuccess());

  } catch (e) {
    emit(PromptError(
      'Failed to send image: $e',
      imageUrl: url,
    ));
  }
}
}