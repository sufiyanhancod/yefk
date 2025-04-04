import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';

export 'askqestion_mobile.dart';
export 'askqestion_web.dart';

class AskqestionScreen extends ConsumerWidget {
  const AskqestionScreen({
    required this.eventId,
    required this.speakerName,
    required this.eventTime,
    super.key,
  });
  final int eventId;

  final String speakerName;
  final String eventTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ResponsiveWidget(
        smallScreen: AskqestionScreenMobile(
          eventId: eventId,
          speakerName: speakerName,
          eventTime: eventTime,
        ),
        largeScreen: AskqestionScreenWeb(),
      ),
    );
  }
}
