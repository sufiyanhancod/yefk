part of 'askquestion_notifier.dart';

enum AskquestionStatus {
  initial,
  loading,
  success,
  error,
  subscribed,
}

extension AskquestionStatusExtension on AskquestionStatus {
  R when<R>({required R Function() initial, required R Function() loading, required R Function() success, required R Function() error, required R Function() subscribed}) {
    switch (this) {
      case AskquestionStatus.initial:
        return initial();
      case AskquestionStatus.loading:
        return loading();
      case AskquestionStatus.success:
        return success();
      case AskquestionStatus.error:
        return error();
      case AskquestionStatus.subscribed:
        return subscribed();
    }
  }
}

@freezed
class AskquestionState with _$AskquestionState {
  const factory AskquestionState({
    @Default(AskquestionStatus.initial) AskquestionStatus status,
    @Default(AskquestionStatus.initial) AskquestionStatus eventStatus,
    @Default([]) List<Questiondetails> question,
  }) = _AskquestionState;

  factory AskquestionState.initial() => const AskquestionState();
}
