import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';

export 'previousquestions_mobile.dart';
export 'previousquestions_web.dart';

class PreviousquestionsScreen extends ConsumerWidget {
  const PreviousquestionsScreen({super.key, required this.eventId});
  final int eventId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveWidget(
        smallScreen: PreviousquestionsScreenMobile(eventId: eventId),
        largeScreen: PreviousquestionsScreenWeb(),
      ),
    );
  }
}
