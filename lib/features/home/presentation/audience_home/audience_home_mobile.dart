import 'package:app/features/home/home.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hancod_theme/colors.dart';

class AudiencehomeScreenMobile extends ConsumerStatefulWidget {
  const AudiencehomeScreenMobile({super.key});

  @override
  ConsumerState<AudiencehomeScreenMobile> createState() => _AudiencehomeScreenMobileState();
}

class _AudiencehomeScreenMobileState extends ConsumerState<AudiencehomeScreenMobile> {
  // Removed SingleTickerProviderStateMixin and TabController
  // We'll use DefaultTabController to simplify implementation
  @override
  void initState() {
    Future.microtask(() {
      ref.read(audiencehomeNotifierProvider.notifier).getEventSchedule();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventScheduleState = ref.watch(audiencehomeNotifierProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: Colors.white),
            ),
          ],
        ),
        body: switch (eventScheduleState.status) {
          AudiencehomeStatus.loading => const Center(child: CircularProgressIndicator(color: AppColors.white)),
          AudiencehomeStatus.success => Column(
              children: [
                // Top section with background and download button
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Blue background with Y pattern
                      Positioned.fill(
                        child: Container(
                          color: AppColors.primaryColor,
                          child: Assets.images.homeBackground.image(fit: BoxFit.cover),
                        ),
                      ),

                      // Download button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: const Text(
                            'DOWNLOAD BROCHURE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade500,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom section with tabs and content
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // TabBar in blue container
                        Container(
                          decoration: const BoxDecoration(
                            // color: Color(0xFF2E70A9),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tab bar
                              TabBar(
                                labelColor: Colors.black,
                                unselectedLabelColor: Color(0xff3c3c4366),
                                indicatorColor: Color(0xFF2E70A9),
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(text: 'DAY 1'),
                                  Tab(text: 'DAY 2'),
                                ],
                              ),

                              // Speakers title
                              Padding(
                                padding: EdgeInsets.only(left: 16, top: 20, bottom: 10),
                                child: Text(
                                  'Speakers',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // TabBarView with speakers list from API data
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Day 1 Content
                              _buildEventsList(eventScheduleState.eventSchedule ?? [], day: 1),

                              // Day 2 Content
                              _buildEventsList(eventScheduleState.eventSchedule ?? [], day: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          AudiencehomeStatus.error => const Center(child: Text('Error loading events')),
          AudiencehomeStatus.initial => const Center(child: Text('Loading events...')),
        },
      ),
    );
  }

  // New method to build events list for a specific day
  Widget _buildEventsList(List<EventSchedule> events, {required int day}) {
    // Filter events for the specified day
    final dayEvents = events.where((event) => event.day == day).toList();

    if (dayEvents.isEmpty) {
      return const Center(
        child: Text(
          'No events scheduled for this day',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: dayEvents.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return SpeakerTile(
          name: event.speakerName,
          time: '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
          speakerId: event.speakerId,
          eventId: event.eventId,
          questionCount: event.questionCount,
          pendingQuestions: event.pendingQuestionsCount,
        );
      },
    );
  }

  // Helper method to format time from database format to display format
  String _formatTime(String time) {
    // Assuming time is in format "HH:MM:SS"
    final timeParts = time.split(':');
    if (timeParts.length < 2) return time;

    int hour = int.tryParse(timeParts[0]) ?? 0;
    final minute = timeParts[1];
    final period = hour >= 12 ? 'pm' : 'am';

    // Convert to 12-hour format
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '$hour.$minute $period';
  }
}

class SpeakerTile extends StatelessWidget {
  final String name;
  final String time;
  final int speakerId;
  final int eventId;
  final int questionCount;
  final int pendingQuestions;

  const SpeakerTile({
    super.key,
    required this.name,
    required this.time,
    required this.speakerId,
    required this.eventId,
    required this.questionCount,
    this.pendingQuestions = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Speaker icon (circle with face)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade300, width: 1),
            ),
            child: const Center(
              child: Icon(
                Icons.person_outline,
                color: Colors.blue,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Speaker info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                if (questionCount > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Questions: $questionCount${pendingQuestions > 0 ? ' ($pendingQuestions pending)' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: pendingQuestions > 0 ? Colors.orange.shade700 : Colors.grey.shade700,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Question mark icon (now a button to add questions)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2B6CA3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              onTap: () {
                // Handle question action here
                // You can navigate to a question form or show a dialog
              },
              child: const Center(
                child: Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
