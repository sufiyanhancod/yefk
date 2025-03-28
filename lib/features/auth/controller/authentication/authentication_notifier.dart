import 'package:app/features/auth/auth.dart';
import 'package:app/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_notifier.freezed.dart';
part 'authentication_notifier.g.dart';
part 'authentication_state.dart';

@Riverpod(keepAlive: false)
class AuthenticationNotifier extends _$AuthenticationNotifier {
  late final IAuthRepository _authRepository;
  @override
  AuthenticationState build() {
    _authRepository = ref.watch(authRepoProvider);
    return AuthenticationState.initial();
  }

  Future<bool> signInWithEmail({required String email, required String password}) async {
    state = state.copyWith(status: AuthenticationStatus.loading);
    try {
      await _authRepository.signInWithEmail(email, password);
      state = state.copyWith(status: AuthenticationStatus.success);
      debugPrint('success');
      AppRouter.goNamed(AppRouter.home);
      return true;
    } catch (e) {
      Alert.showSnackBar(e.toString());
      debugPrint(e.toString());
      state = state.copyWith(status: AuthenticationStatus.error);
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthenticationStatus.loading);
    await _authRepository.signOut();
    state = state.copyWith(status: AuthenticationStatus.initial);
    AppRouter.goNamed(AppRouter.login);
  }

  Future<void> signUpUser({required String email, required String password, required String name, required String userType}) async {
    state = state.copyWith(status: AuthenticationStatus.loading);
    await _authRepository.signUpUser(email: email, password: password, name: name, userType: userType);
    state = state.copyWith(status: AuthenticationStatus.success);
  }
}
