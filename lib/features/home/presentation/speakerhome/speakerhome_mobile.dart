import 'package:app/features/home/home.dart';
import 'package:app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/hancod_theme.dart';

class SpeakerhomeScreenMobile extends ConsumerStatefulWidget {
  const SpeakerhomeScreenMobile({super.key});

  @override
  ConsumerState<SpeakerhomeScreenMobile> createState() => _SpeakerhomeScreenMobileState();
}

class _SpeakerhomeScreenMobileState extends ConsumerState<SpeakerhomeScreenMobile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(askquestionNotifierProvider.notifier).getQuestionbySpeaker(ref.read(supabaseProvider).auth.currentUser!.id, 'ACCEPTED');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          ref.read(supabaseProvider).auth.currentUser!.userMetadata?['name'] as String,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: switch (ref.watch(askquestionNotifierProvider).status) {
        AskquestionStatus.loading => const Center(child: CircularProgressIndicator()),
        AskquestionStatus.error => const Center(child: Text('Error')),
        AskquestionStatus.success => ref.watch(askquestionNotifierProvider).question.isEmpty
            ? const Center(
                child: Text(
                  'No Questions Available',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: ref.watch(askquestionNotifierProvider).question.length,
                itemBuilder: (context, index) {
                  final question = ref.watch(askquestionNotifierProvider).question[index];
                  return QuestionCard(
                    questionId: question.questionId ?? 0,
                    userId: question.speakerId ?? '',
                    userName: question.userName ?? '',
                    question: question.questionText ?? '',
                    timestamp: question.createdAt ?? '',
                    isCompleted: question.questionStatus != 'ANSWERED',
                    isActive: question.questionStatus == 'ACCEPTED',
                  );
                },
              ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

class QuestionCard extends ConsumerWidget {
  const QuestionCard({
    required this.userName,
    required this.question,
    required this.timestamp,
    required this.questionId,
    required this.userId,
    this.isCompleted = false,
    this.isActive = false,
    super.key,
  });
  final String userName;
  final String question;
  final String timestamp;
  final String userId;
  final int questionId;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: isCompleted ? const Color(0xFFF6F6F6) : Colors.lightGreen.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: const Icon(Icons.person_outline, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        question,
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        timestamp,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (isCompleted)
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        //backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: AppColors.primaryColor, width: 2),
                        ),
                      ),
                      onPressed: () {
                        ref.read(askquestionNotifierProvider.notifier).updatespeackerQStatus(questionId, 'ANSWERED', userId);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('Completed'),
                      ),
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
