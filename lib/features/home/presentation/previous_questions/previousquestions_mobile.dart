import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/colors.dart';

class PreviousquestionsScreenMobile extends ConsumerStatefulWidget {
  const PreviousquestionsScreenMobile({super.key});

  @override
  ConsumerState<PreviousquestionsScreenMobile> createState() => _PreviousquestionsScreenMobileState();
}

class _PreviousquestionsScreenMobileState extends ConsumerState<PreviousquestionsScreenMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Previous Questions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recently Asked Questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5, // Replace with actual data length
              itemBuilder: (context, index) {
                return QuestionHistoryCard(
                  speakerName: 'Ar.Sudarshan Holla',
                  question: index == 0
                      ? 'Can you describe your design philosophy in a few words?'
                      : index == 1
                          ? 'How do you balance aesthetics and functionality in your designs?'
                          : 'What has been your most challenging project, and how did you overcome it?',
                  timestamp: 'Today, ${11 - index}:23 am',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionHistoryCard extends StatelessWidget {
  final String speakerName;
  final String question;
  final String timestamp;

  const QuestionHistoryCard({
    super.key,
    required this.speakerName,
    required this.question,
    required this.timestamp,
  });

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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
              child: Icon(
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
