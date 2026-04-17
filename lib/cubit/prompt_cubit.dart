import 'package:flutter_bloc/flutter_bloc.dart';

part 'prompt_state.dart';

class PromptCubit extends Cubit<PromptState> {
  PromptCubit() : super(const PromptInitial());

 
  Future<void> sendPrompt(String prompt) async {
    emit(PromptLoading(screenState: state.screenState, imageUrl: state.imageUrl));

    try {
      //todo

      await Future.delayed(const Duration(seconds: 2)); // Simulate API
      const imageUrl = 'https://via.placeholder.com/400x300?text=AI+Generated';

      emit(const PromptImageReady(imageUrl: imageUrl));
    } catch (e) {
      emit(PromptError(
        message: 'Error: $e',
        screenState: PromptScreenState.inputPrompt,
      ));
    }
  }

  Future<void> sendEdits(String edits) async {
    emit(PromptLoading(screenState: state.screenState, imageUrl: state.imageUrl));

    try {
     //todo
      await Future.delayed(const Duration(seconds: 2)); // Simulate API
      const imageUrl = 'https://via.placeholder.com/400x300?text=Revised+Image';

      emit(const PromptImageReady(imageUrl: imageUrl));
    } catch (e) {
      emit(PromptError(
        message: 'Error: $e',
        screenState: PromptScreenState.showImage,
        imageUrl: state.imageUrl,
      ));
    }
  }

  Future<void> sendFinalImageForGCode() async {
    final currentImageUrl = state.imageUrl;
    emit(PromptLoading(screenState: state.screenState, imageUrl: currentImageUrl));

    try {
    //todo
      await Future.delayed(const Duration(seconds: 2)); // Simulate API

      emit(const PromptSentSuccess());
    } catch (e) {
      emit(PromptError(
        message: 'Error: $e',
        screenState: PromptScreenState.showImage,
        imageUrl: currentImageUrl,
      ));
    }
  }

  void goToEdits() => emit(PromptInputEdits(imageUrl: state.imageUrl));

  void goBackToImage() => emit(PromptImageReady(imageUrl: state.imageUrl ?? ''));

  void goBackToPrompt() => emit(const PromptInitial());
}