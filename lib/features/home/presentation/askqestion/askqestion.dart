import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';

export 'askqestion_mobile.dart';
export 'askqestion_web.dart';

class AskqestionScreen extends ConsumerWidget {
  const AskqestionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ResponsiveWidget(
        smallScreen: AskqestionScreenMobile(
          eventId: 0,
          speakerId: 0,
          speakerName: 'Test',
          eventTime: 'Test',
        ),
        largeScreen: AskqestionScreenWeb(),
      ),
    );
  }
}
