part of 'normaluserlogin_notifier.dart';

enum NormaluserloginStatus {
    initial,
    loading,
    success,
    error,
}

extension NormaluserloginStatusExtension on NormaluserloginStatus {
    R when<R>({
      required R Function() initial,
      required R Function() loading,
      required R Function() success,
      required R Function() error,
    }) {
      switch (this) {
        case NormaluserloginStatus.initial:
          return initial();
        case NormaluserloginStatus.loading:
          return loading();
        case NormaluserloginStatus.success:
          return success();
        case NormaluserloginStatus.error:
          return error();
      }
    }
  }

@freezed
class NormaluserloginState with _$NormaluserloginState {
    const factory NormaluserloginState({
    @Default(NormaluserloginStatus.initial) NormaluserloginStatus status,
    }) = _NormaluserloginState;

    factory NormaluserloginState.initial() => const NormaluserloginState();
}
