import 'package:app/features/home/presentation/reviewquestions/reviewquestions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/shared/shared.dart';

export 'reviewquestions_mobile.dart';
export 'reviewquestions_web.dart';

class ReviewquestionsScreen extends ConsumerWidget {
  const ReviewquestionsScreen({
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
        smallScreen: ReviewquestionsScreenMobile(
          eventId: eventId,
          speakerName: speakerName,
          eventTime: eventTime,
        ),
        largeScreen: const ReviewquestionsScreenWeb(),
      ),
    );
  }
}
