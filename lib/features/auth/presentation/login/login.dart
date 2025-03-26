import 'package:app/features/auth/auth.dart';
import 'package:app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'login_mobile.dart';
export 'login_web.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: LoginScreenWeb(),
        largeScreen: LoginScreenMobile(),
      ),
    );
  }
}
