import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/auth/auth.dart';
import 'package:app/shared/shared.dart';

export 'adminlogin_mobile.dart';
export 'adminlogin_web.dart';

class AdminloginScreen extends ConsumerWidget {
  const AdminloginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: AdminloginScreenMobile(),
        largeScreen: AdminloginScreenWeb(),
      ),
    );
  }
}
