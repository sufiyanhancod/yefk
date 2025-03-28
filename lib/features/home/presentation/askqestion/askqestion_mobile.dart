import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/colors.dart';

class AskqestionScreenMobile extends ConsumerStatefulWidget {
  const AskqestionScreenMobile({
    required this.eventId,
    required this.speakerId,
    required this.speakerName,
    required this.eventTime,
    super.key,
  });

  final int eventId;
  final int speakerId;
  final String speakerName;
  final String eventTime;
  @override
  ConsumerState<AskqestionScreenMobile> createState() => _AskqestionScreenMobileState();
}

class _AskqestionScreenMobileState extends ConsumerState<AskqestionScreenMobile> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Ask Question',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Speaker info card
            askQuestioncontainer(context),

            const SizedBox(height: 24),

            // Previously asked questions
            previousAskContainer(),
          ],
        ),
      ),
    );
  }

  InkWell previousAskContainer() {
    return InkWell(
      onTap: () {
        // TODO: Navigate to previously asked questions screen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Container(
            //   width: 40,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //     border: Border.all(color: AppColors.primaryColor, width: 2),
            //   ),
            //   child: const Center(
            //     child: Icon(
            //       Icons.question_answer_outlined,
            //       color: AppColors.primaryColor,
            //       size: 20,
            //     ),
            //   ),
            // ),
            Assets.icons.questionIcon.image(),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Previously Asked QNS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Container askQuestioncontainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Question icon
              // Container(
              //   width: 40,
              //   height: 40,
              //   decoration: BoxDecoration(
              //     color: AppColors.primaryColor.withOpacity(0.1),
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: const Center(
              //     child: Icon(
              //       Icons.question_mark,
              //       color: AppColors.primaryColor,
              //       size: 24,
              //     ),
              //   ),
              // ),
              Assets.icons.askQuestionIcon.image(),
              const SizedBox(width: 16),
              // Speaker details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ask a Question to',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.speakerName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.eventTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Question text field
          TextField(
            controller: _questionController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Ask Anything...',
              hintStyle: TextStyle(color: Color(0xFFA9A9A9)),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.secondary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: AppColors.secondary),
              ),
              contentPadding: EdgeInsets.all(16),
              filled: true,
              fillColor: AppColors.secondary,
            ),
          ),

          const SizedBox(height: 16),

          // Button row
          Row(
            children: [
              // Clear button
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _questionController.clear();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Send button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_questionController.text.trim().isNotEmpty) {
                      // TODO: Implement sending question
                      // Use: widget.eventId, widget.speakerId, _questionController.text

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Question submitted successfully')),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a question')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
