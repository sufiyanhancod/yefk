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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Ar.Sudharshan Holla',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6, // Replace with actual data length
        itemBuilder: (context, index) {
          return QuestionCard(
            userName: 'Aaaa',
            question: 'Can you describe your design philosophy in a few words?',
            timestamp: 'Today, 09.23 am',
            isCompleted: index == 0, // Example condition
            isActive: index == 1,
          );
        },
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required this.userName,
    required this.question,
    required this.timestamp,
    this.isCompleted = false,
    this.isActive = false,
    super.key,
  });
  final String userName;
  final String question;
  final String timestamp;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? const Color(0xFFF6F6F6) : Colors.lightGreen.withOpacity(0.1),
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
                      onPressed: () {},
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
