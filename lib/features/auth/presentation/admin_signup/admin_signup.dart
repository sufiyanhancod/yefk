import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/shared/shared.dart';

export 'admin_signup_mobile.dart';
export 'admin_signup_web.dart';

class AdminsignupScreen extends ConsumerWidget {
  const AdminsignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: AdminsignupScreenMobile(),
        largeScreen: AdminsignupScreenWeb(),
      ),
    );
  }
}
