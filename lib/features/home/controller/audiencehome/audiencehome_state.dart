part of 'audiencehome_notifier.dart';

enum AudiencehomeStatus {
  initial,
  loading,
  success,
  error,
}

extension AudiencehomeStatusExtension on AudiencehomeStatus {
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function() success,
    required R Function() error,
  }) {
    switch (this) {
      case AudiencehomeStatus.initial:
        return initial();
      case AudiencehomeStatus.loading:
        return loading();
      case AudiencehomeStatus.success:
        return success();
      case AudiencehomeStatus.error:
        return error();
    }
  }
}

@freezed
class AudiencehomeState with _$AudiencehomeState {
  const factory AudiencehomeState({
    @Default(AudiencehomeStatus.initial) AudiencehomeStatus status,
    List<EventSchedule>? eventSchedule,
  }) = _AudiencehomeState;

  factory AudiencehomeState.initial() => const AudiencehomeState();
}
