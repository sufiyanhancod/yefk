part of 'askquestion_notifier.dart';

enum AskquestionStatus {
    initial,
    loading,
    success,
    error,
}

extension AskquestionStatusExtension on AskquestionStatus {
    R when<R>({
      required R Function() initial,
      required R Function() loading,
      required R Function() success,
      required R Function() error,
    }) {
      switch (this) {
        case AskquestionStatus.initial:
          return initial();
        case AskquestionStatus.loading:
          return loading();
        case AskquestionStatus.success:
          return success();
        case AskquestionStatus.error:
          return error();
      }
    }
  }

@freezed
class AskquestionState with _$AskquestionState {
    const factory AskquestionState({
    @Default(AskquestionStatus.initial) AskquestionStatus status,
    }) = _AskquestionState;

    factory AskquestionState.initial() => const AskquestionState();
}
