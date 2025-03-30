import 'package:app/features/home/presentation/speakerhome/speakerhome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/shared/shared.dart';

export 'speakerhome_mobile.dart';
export 'speakerhome_web.dart';

class SpeakerhomeScreen extends ConsumerWidget {
  const SpeakerhomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: SpeakerhomeScreenMobile(),
        largeScreen: SpeakerhomeScreenWeb(),
      ),
    );
  }
}
