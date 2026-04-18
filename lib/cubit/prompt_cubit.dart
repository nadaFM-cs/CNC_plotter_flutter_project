import 'package:http/http.dart' as http;
import 'package:cnc_plotter/constant/image_const.dart';
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

      emit(const PromptImageReady(
        imageUrl: 'https://example.com/generated.png',
      ));
    } catch (e) {
      emit(PromptError('Failed to generate image: $e'));
    }
  }

  Future<void> sendEdits(String edits) async {
    final currentUrl = state.imageUrl;

    emit(PromptLoading(
      screenState: PromptScreenState.inputEdits,
      imageUrl: currentUrl,
    ));

    try {
      await Future.delayed(const Duration(seconds: 2));

      emit(PromptImageReady(imageUrl: currentUrl ?? ''));
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

    emit(PromptLoading(
      screenState: PromptScreenState.showImage,
      imageUrl: url,
    ));

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      final rawBytes = response.bodyBytes;

      final a4Bytes = await resizeToA4Png(rawBytes);

      await Future.delayed(const Duration(seconds: 2));

      emit(const PromptSentSuccess());
    } catch (e) {
      emit(PromptError(
        'Failed to send: $e',
        imageUrl: url,
      ));
    }
  }
}