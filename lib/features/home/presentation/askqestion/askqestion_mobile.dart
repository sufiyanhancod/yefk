import 'package:app/features/home/controller/askquestion/askquestion_notifier.dart';
import 'package:app/features/home/presentation/widgets/success_dialog.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/shared/providers/shared_prefs_provider/shared_prefs_provider.dart';
import 'package:app/shared/providers/supabase_provider/supabase_provider.dart';
import 'package:app/shared/utils/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_theme/colors.dart';

class AskqestionScreenMobile extends ConsumerStatefulWidget {
  const AskqestionScreenMobile({
    required this.eventId,
    required this.speakerName,
    required this.eventTime,
    super.key,
  });

  final int eventId;
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
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.black),
            onPressed: () {
              ref.read(supabaseProvider).auth.signOut();
              context.goNamed(AppRouter.login);
            },
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
        context.pushNamed(AppRouter.previousQuestions, extra: {'eventId': widget.eventId});
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
                  onPressed: () async {
                    String? email;
                    String? name;
                    if (_questionController.text.trim().isNotEmpty) {
                      if (ref.read(supabaseProvider).auth.currentUser != null) {
                        email = ref.read(supabaseProvider).auth.currentUser?.email ?? '';
                        name = ref.read(supabaseProvider).auth.currentUser?.userMetadata?['name'] as String;
                      } else {
                        final prefs = await ref.read(sharedPrefsProvider.future);
                        email = prefs.getString('email') ?? '';
                        name = prefs.getString('name') ?? '';
                      }
                      await ref.read(askquestionNotifierProvider.notifier).askQuestion(
                            questionStatus: ref.read(supabaseProvider).auth.currentUser != null ? 'ACCEPTED' : 'PENDING',
                            question: _questionController.text,
                            email: email,
                            name: name,
                            eventId: widget.eventId,
                          );

                      if (context.mounted) {
                        // Show success dialog instead of Snackbar
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const SuccessDialog(),
                        );
                        // Optional: Navigate back after dialog is closed
                        if (context.mounted) {
                          _questionController.clear();
                          //    context.goNamed(AppRouter.audienceHome);
                        }
                      }
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
