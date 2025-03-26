import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/hancod_theme.dart';

class LoginScreenMobile extends ConsumerStatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  ConsumerState<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends ConsumerState<LoginScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Text(
            'Login Screen Mobile',
            style: AppText.heading1,
          ),
        ],
      ),
    );
  }
}
