import 'package:app/features/home/home.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/shared/shared.dart';
import 'package:app/shared/utils/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_theme/colors.dart';

class ReviewquestionsScreenMobile extends ConsumerStatefulWidget {
  const ReviewquestionsScreenMobile({
    required this.eventId,
    required this.speakerName,
    required this.eventTime,
    super.key,
  });
  final int eventId;
  final String speakerName;
  final String eventTime;

  @override
  ConsumerState<ReviewquestionsScreenMobile> createState() => _ReviewquestionsScreenMobileState();
}

class _ReviewquestionsScreenMobileState extends ConsumerState<ReviewquestionsScreenMobile> {
  bool switchValue = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(askquestionNotifierProvider.notifier).getQuestionbyModerator(widget.eventId, 'PENDING');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: AppColors.black,
        ),
        title: const Text('Review Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(supabaseProvider).auth.signOut();
              context.goNamed(AppRouter.login);
            },
            color: AppColors.black,
          ),
        ],
      ),
      body: switch (ref.watch(askquestionNotifierProvider).status) {
        AskquestionStatus.loading => const Center(child: CircularProgressIndicator()),
        AskquestionStatus.success => Column(
            children: [
              // Toggle switch section
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColors.secondary),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.speakerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CupertinoSwitch(
                      activeColor: AppColors.primaryColor,
                      value: switchValue,
                      onChanged: (value) async {
                        if (value == false) {
                          final shouldDisable = await showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => DisableSpeakerDialog(eventId: widget.eventId),
                          );

                          if (shouldDisable == true) {
                            setState(() {
                              switchValue = false;
                            });
                          }
                        } else {
                          setState(() {
                            switchValue = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Questions list
              Expanded(
                child: ListView.builder(
                  itemCount: ref.watch(askquestionNotifierProvider).question.length, // Replace with actual question count
                  itemBuilder: (context, index) {
                    final question = ref.watch(askquestionNotifierProvider).question[index];
                    return QuestionCard(
                      eventId: widget.eventId,
                      questionId: question.questionId!,
                      profileImage: Assets.icons.profile.svg(), // Add actual asset
                      userName: question.userName ?? '',
                      question: question.questionText ?? '',
                      timestamp: question.createdAt ?? '',
                      isFirstQuestion: index == 0,
                    );
                  },
                ),
              ),
              // Bottom button
              // Bottom button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppRouter.askQuestion, extra: {
                        'eventId': widget.eventId,
                        'speakerName': widget.speakerName,
                        'eventTime': widget.eventTime,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Ask Question',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        AskquestionStatus.error => const Center(child: Text('Error')),
        AskquestionStatus.initial => const Center(child: Text('Initial')),
        AskquestionStatus.subscribed => const Center(child: Text('subscribed')),
      },
    );
  }
}

// Separate widget for question card
class QuestionCard extends ConsumerWidget {
  const QuestionCard({
    required this.profileImage,
    required this.userName,
    required this.question,
    required this.timestamp,
    required this.questionId,
    required this.eventId,
    super.key,
    this.isFirstQuestion = false,
  });
  final Widget profileImage;
  final String userName;
  final String question;
  final String timestamp;
  final bool isFirstQuestion;
  final int questionId;
  final int eventId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(color: AppColors.secondary),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Removes the borders
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          // Remove the default trailing icon color
          iconColor: Colors.grey,
          title: Row(
            children: [
              profileImage,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Ensure text color stays black
                      ),
                    ),
                    Text(
                      question,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87, // Ensure text color stays dark
                      ),
                    ),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(askquestionNotifierProvider.notifier).updateQuestionStatus(questionId, 'REJECTED', eventId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(askquestionNotifierProvider.notifier).updateQuestionStatus(questionId, 'ACCEPTED', eventId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[100],
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Add this custom dialog widget
class DisableSpeakerDialog extends ConsumerWidget {
  const DisableSpeakerDialog({super.key, required this.eventId});
  final int eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Colors.red.shade700,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Disable Speaker?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "This action will deactivate speaker access permanently. You won't be able to undo this later.",
              //textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD92D20),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                  ref.read(askquestionNotifierProvider.notifier).updateEventStatus(eventId, 'false').then((value) {
                    if (value) {
                      Alert.showSnackBar('Speaker disabled successfully');
                      ref.read(audiencehomeNotifierProvider.notifier).getEventSchedule();
                      context.goNamed(AppRouter.audienceHome);
                    } else {
                      Alert.showSnackBar('Failed to disable speaker');
                    }
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    'Disable',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
