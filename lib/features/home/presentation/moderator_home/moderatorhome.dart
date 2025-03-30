import 'package:app/features/home/presentation/moderator_home/moderatorhome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';

export 'moderatorhome_mobile.dart';
export 'moderatorhome_web.dart';

class ModeratorhomeScreen extends ConsumerWidget {
  const ModeratorhomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: ModeratorhomeScreenMobile(),
        largeScreen: ModeratorhomeScreenWeb(),
      ),
    );
  }
}
