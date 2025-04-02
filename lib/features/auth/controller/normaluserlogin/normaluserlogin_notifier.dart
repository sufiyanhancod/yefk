import 'package:app/shared/providers/shared_prefs_provider/shared_prefs_provider.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'normaluserlogin_notifier.freezed.dart';
part 'normaluserlogin_notifier.g.dart';
part 'normaluserlogin_state.dart';

@Riverpod(keepAlive: false)
class NormaluserloginNotifier extends _$NormaluserloginNotifier {
  @override
  NormaluserloginState build() {
    return NormaluserloginState.initial();
  }

  Future<void> saveUserDataToLocalStorage({
    required String email,
    required String phoneNumber,
  }) async {
    state = state.copyWith(status: NormaluserloginStatus.loading);

    try {
      final prefs = await ref.read(sharedPrefsProvider.future);

      await prefs.setString('email', email);
      await prefs.setString('name', phoneNumber);

      state = state.copyWith(status: NormaluserloginStatus.success);
      debugPrint('User data saved to local storage');
      debugPrint(prefs.getString('email'));
      debugPrint(prefs.getString('name'));
    } catch (e) {
      state = state.copyWith(status: NormaluserloginStatus.error);
    }
  }
}
