import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';

export 'audience_\home_mobile.dart';
export 'audience_home_web.dart';

class AudiencehomeScreen extends ConsumerWidget {
  const AudiencehomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: AudiencehomeScreenMobile(),
        largeScreen: AudiencehomeScreenWeb(),
      ),
    );
  }
}
