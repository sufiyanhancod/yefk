import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/hancod_theme.dart';
// Import your timer provider

class TimerNotifier extends StateNotifier<Duration> {
  Timer? _timer; // Add timer variable to properly manage the timer

  TimerNotifier() : super(Duration.zero) {
    // Set target date to March 16th of the current year
    final now = DateTime.now();
    DateTime targetDate = DateTime(now.year, 3, 16, 23, 59, 59);

    // If March 16th has already passed this year, use next year's date
    if (targetDate.isBefore(now)) {
      targetDate = DateTime(now.year + 1, 3, 16, 23, 59, 59);
    }

    calculateTimeLeft(targetDate);

    // Update every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      calculateTimeLeft(targetDate);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when disposing
    super.dispose();
  }

  void calculateTimeLeft(DateTime targetDate) {
    final now = DateTime.now();
    final difference = targetDate.difference(now);

    // For debugging
    // print('Target date: $targetDate');
    // print('Current time: $now');
    // print('Difference: $difference');

    if (difference.isNegative) {
      state = Duration.zero;
    } else {
      state = difference;
    }
  }
}

final timerProvider = StateNotifierProvider<TimerNotifier, Duration>((ref) {
  return TimerNotifier();
});

class TimmerRow extends ConsumerWidget {
  const TimmerRow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(timerProvider);

    return Column(
      children: [
        const Text(
          'LIVE TIME:',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TimeBox(value: duration.inDays.toString().padLeft(2, '0'), label: 'Days'),
            TimeBox(value: (duration.inHours % 24).toString().padLeft(2, '0'), label: 'Hours'),
            TimeBox(value: (duration.inMinutes % 60).toString().padLeft(2, '0'), label: 'Minutes'),
            TimeBox(value: (duration.inSeconds % 60).toString().padLeft(2, '0'), label: 'Second'),
          ],
        ),
      ],
    );
  }
}

class TimeBox extends StatelessWidget {
  const TimeBox({
    required this.value,
    required this.label,
    super.key,
  });
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
