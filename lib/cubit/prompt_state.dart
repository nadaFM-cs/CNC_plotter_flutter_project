import 'dart:io';

enum PromptScreenState { inputPrompt, showImage, inputEdits }

abstract class PromptState {
  final PromptScreenState screenState;
  final File? imageFile;

  const PromptState({
    required this.screenState,
    this.imageFile,
  });
}

class PromptInitial extends PromptState {
  const PromptInitial()
      : super(screenState: PromptScreenState.inputPrompt);
}

class PromptLoading extends PromptState {
  const PromptLoading({
    PromptScreenState screenState = PromptScreenState.inputPrompt,
    File? imageFile,
  }) : super(screenState: screenState, imageFile: imageFile);
}

class PromptImageReady extends PromptState {
  const PromptImageReady({required File imageFile})
      : super(
    screenState: PromptScreenState.showImage,
    imageFile: imageFile,
  );
}

class PromptEditMode extends PromptState {
  const PromptEditMode(File imageFile)
      : super(
    screenState: PromptScreenState.inputEdits,
    imageFile: imageFile,
  );
}

class PromptSentSuccess extends PromptState {
  const PromptSentSuccess()
      : super(screenState: PromptScreenState.showImage);
}

class PromptError extends PromptState {
  final String message;

  const PromptError(
      this.message, {
        File? imageFile,
      }) : super(
    screenState: PromptScreenState.showImage,
    imageFile: imageFile,
  );
}