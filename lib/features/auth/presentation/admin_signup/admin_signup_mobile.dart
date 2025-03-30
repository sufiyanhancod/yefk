import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminsignupScreenMobile extends ConsumerStatefulWidget {
  const AdminsignupScreenMobile({super.key});

  @override
  ConsumerState<AdminsignupScreenMobile> createState() => _AdminsignupScreenMobileState();
}

class _AdminsignupScreenMobileState extends ConsumerState<AdminsignupScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Admin Signup'),
      ),
    );
  }
}
