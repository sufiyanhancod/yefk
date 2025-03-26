part of 'authentication_notifier.dart';

enum AuthenticationStatus {
  initial,
  loading,
  success,
  error,
}

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    @Default(AuthenticationStatus.initial) AuthenticationStatus status,
  }) = _AuthenticationState;

  factory AuthenticationState.initial() => const AuthenticationState();
}
