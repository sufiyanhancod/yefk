import 'dart:async';
import 'dart:developer';

import 'package:app/features/home/controller/askquestion/askquestion_notifier.dart';
import 'package:app/shared/providers/shared_prefs_provider/shared_prefs_provider.dart';
import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:app/shared/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_theme/colors.dart';

class PreviousquestionsScreenMobile extends ConsumerStatefulWidget {
  const PreviousquestionsScreenMobile({super.key, required this.eventId});
  final int eventId;
  @override
  ConsumerState<PreviousquestionsScreenMobile> createState() => _PreviousquestionsScreenMobileState();
}

class _PreviousquestionsScreenMobileState extends ConsumerState<PreviousquestionsScreenMobile> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      String email;
      if (ref.read(supabaseProvider).auth.currentUser != null) {
        email = ref.read(supabaseProvider).auth.currentUser!.email!;
      } else {
        final prefs = await ref.read(sharedPrefsProvider.future);
        email = prefs.getString('email') ?? '';
      }
      await ref.read(askquestionNotifierProvider.notifier).getPreviousQuestions(email, widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text('Previous Questions', style: TextStyle(color: AppColors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.black),
            onPressed: () async {
              if (ref.read(supabaseProvider).auth.currentUser != null) {
                await ref.read(supabaseProvider).auth.signOut();
                context.goNamed(AppRouter.login);
              } else {
                log('Shared pref cleanning worked');
                final prefs = await ref.read(sharedPrefsProvider.future);
                await prefs.remove('email');
                await prefs.remove('name');
                context.goNamed(AppRouter.login);
              }
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          switch (ref.watch(askquestionNotifierProvider).status) {
            AskquestionStatus.loading => const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            AskquestionStatus.error => const Expanded(
                child: Center(
                  child: Text(
                    'Something went wrong',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            AskquestionStatus.success => ref.watch(askquestionNotifierProvider).question.isEmpty
                ? const Expanded(
                    child: Center(
                      child: Text(
                        'No questions asked yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: ref.watch(askquestionNotifierProvider).question.length,
                      itemBuilder: (context, index) {
                        final question = ref.watch(askquestionNotifierProvider).question[index];
                        return QuestionHistoryCard(
                          speakerName: question.speakerName ?? '',
                          question: question.questionText ?? '',
                          timestamp: _formatTimestamp(question.createdAt ?? ''),
                          status: question.questionStatus ?? '',
                        );
                      },
                    ),
                  ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      return timestamp;
    }
  }
}

class QuestionHistoryCard extends StatelessWidget {
  const QuestionHistoryCard({
    required this.speakerName,
    required this.question,
    required this.timestamp,
    required this.status,
    super.key,
  });
  final String speakerName;
  final String question;
  final String timestamp;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.secondary,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.question_answer_outlined,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$speakerName:',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    question,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
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
      ),
    );
  }
}
