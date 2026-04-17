part of 'prompt_cubit.dart';


enum PromptScreenState { inputPrompt, showImage, inputEdits }

abstract class PromptState {
  final PromptScreenState screenState;
  final String? imageUrl;

  const PromptState({required this.screenState, this.imageUrl});
}

class PromptInitial extends PromptState {
  const PromptInitial() : super(screenState: PromptScreenState.inputPrompt);
}


class PromptLoading extends PromptState {
  const PromptLoading({required super.screenState, super.imageUrl});
}


class PromptImageReady extends PromptState {
  const PromptImageReady({required String imageUrl})
      : super(screenState: PromptScreenState.showImage, imageUrl: imageUrl);
}


class PromptInputEdits extends PromptState {
  const PromptInputEdits({super.imageUrl})
      : super(screenState: PromptScreenState.inputEdits);
}


class PromptSentSuccess extends PromptState {
  const PromptSentSuccess()
      : super(screenState: PromptScreenState.showImage);
}


class PromptError extends PromptState {
  final String message;
  const PromptError({required this.message, required super.screenState, super.imageUrl});
}