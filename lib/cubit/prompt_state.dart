enum PromptScreenState { inputPrompt, showImage, inputEdits }

abstract class PromptState {
  final PromptScreenState screenState;
  final String? imageUrl;

  const PromptState({required this.screenState, this.imageUrl});
}



class PromptInitial extends PromptState {
  const PromptInitial()
      : super(screenState: PromptScreenState.inputPrompt);
}


class PromptLoading extends PromptState {
  const PromptLoading({
    PromptScreenState screenState = PromptScreenState.inputPrompt,
    String? imageUrl,
  }) : super(screenState: screenState, imageUrl: imageUrl);
}

class PromptImageReady extends PromptState {
  const PromptImageReady({required String imageUrl})
      : super(
          screenState: PromptScreenState.showImage,
          imageUrl: imageUrl,
        );
}

class PromptEditMode extends PromptState {
  const PromptEditMode(String imageUrl)
      : super(
          screenState: PromptScreenState.inputEdits,
          imageUrl: imageUrl,
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
    PromptScreenState screenState = PromptScreenState.showImage,
    String? imageUrl,
  }) : super(screenState: screenState, imageUrl: imageUrl);
}