import 'package:app/features/auth/auth.dart';
import 'package:app/features/home/home.dart';
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

  Future<void> signInWithPhone({required String phoneNumber, required String name, required String email}) async {
    state = state.copyWith(status: AuthenticationStatus.loading);
    try {
      await _authRepository.signInWithPhone(phoneNumber, name, email);
      state = state.copyWith(status: AuthenticationStatus.success);
      debugPrint('success');
      AppRouter.goNamed(AppRouter.home);
    } catch (e) {
      debugPrint(e.toString());
      state = state.copyWith(status: AuthenticationStatus.error);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(status: AuthenticationStatus.loading);
    await _authRepository.signOut();
    state = state.copyWith(status: AuthenticationStatus.initial);
    AppRouter.goNamed(AppRouter.login);
  }
}
