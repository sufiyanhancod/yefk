import 'package:app/features/home/home.dart';
import 'package:app/gen/assets.gen.dart';
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
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
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
                      value: true, // You'll need to manage this state
                      onChanged: (value) {
                        // Handle switch state
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
          tilePadding: const EdgeInsets.all(16.0),
          childrenPadding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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
