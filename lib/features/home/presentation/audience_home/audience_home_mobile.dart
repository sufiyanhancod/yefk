import 'package:app/features/home/home.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hancod_theme/colors.dart';
import 'package:universal_html/html.dart' as html;

class AudiencehomeScreenMobile extends ConsumerStatefulWidget {
  const AudiencehomeScreenMobile({super.key});

  @override
  ConsumerState<AudiencehomeScreenMobile> createState() => _AudiencehomeScreenMobileState();
}

class _AudiencehomeScreenMobileState extends ConsumerState<AudiencehomeScreenMobile> {
  void _downloadPdfWeb(String url) {
    // Create a blob URL for direct download
    html.AnchorElement anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'yefk_brochure.pdf')
      ..style.display = 'none';

    html.document.body?.children.add(anchor);
    anchor.click();

    // Cleanup
    html.document.body?.children.remove(anchor);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audiencehomeNotifierProvider.notifier).getEventSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final authState = ref.watch(supabaseProvider).auth.currentUser;
    //  debugPrint(authState?.userMetadata?['name'] as String);
    final eventScheduleState = ref.watch(audiencehomeNotifierProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          // ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(supabaseProvider).auth.signOut();
                context.goNamed(AppRouter.login);
              },
              icon: const Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        body: switch (eventScheduleState.status) {
          AudiencehomeStatus.loading => const Center(child: CircularProgressIndicator(color: AppColors.white)),
          AudiencehomeStatus.success => Column(
              children: [
                // Top section with background and download button
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                          onPressed: () => _downloadPdfWeb('https://ngmqewfobapfktlshmkv.supabase.co/storage/v1/object/public/assets//YAF.K%20Brochure-1.pdf'),
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
                              _buildEventsList(eventScheduleState.eventSchedule ?? [], day: 1, isUser: ref.watch(supabaseProvider).auth.currentUser != null),

                              // Day 2 Content
                              _buildEventsList(eventScheduleState.eventSchedule ?? [], day: 2, isUser: ref.watch(supabaseProvider).auth.currentUser != null),
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
  Widget _buildEventsList(List<EventSchedule> events, {required int day, required bool isUser}) {
    // Filter events for the specified day
    final dayEvents = events.where((event) => event.day == 'day-$day').toList()..sort((a, b) => _compareTime(a.startTime, b.startTime)); // Sort by start time

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
          tileColor: event.eventStatus ? AppColors.secondary : const Color(0xFFE0E0E0),
          trailingIcon: isUser ? Assets.icons.eyeIcon.svg() : Assets.icons.questionMarkIcons.svg(),
          onTap: () {
            if (event.eventStatus) {
              if (isUser) {
                context.pushNamed(
                  AppRouter.reviewQuestions,
                  extra: {
                    'eventId': event.eventId,
                    'speakerName': event.speakerName,
                    'eventTime': '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                  },
                );
              } else {
                context.pushNamed(
                  AppRouter.askQuestion,
                  extra: {
                    'eventId': event.eventId,
                    'speakerName': event.speakerName,
                    'eventTime': '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
                  },
                );
              }
              //Alert.showSnackBar('Please login to ask questions');
            } else {
              Alert.showSnackBar('Speaker is disabled');
            }
          },
          name: event.speakerName,
          time: '${_formatTime(event.startTime)} - ${_formatTime(event.endTime)}',
          speakerId: event.speakerId,
          eventId: event.eventId,
          questionCount: 0,
          pendingQuestions: 0,
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

  // Add this helper method for time comparison
  int _compareTime(String time1, String time2) {
    // Convert time strings to comparable format
    final t1Parts = time1.split(':').map(int.parse).toList();
    final t2Parts = time2.split(':').map(int.parse).toList();

    // Compare hours first
    if (t1Parts[0] != t2Parts[0]) {
      return t1Parts[0].compareTo(t2Parts[0]);
    }
    // If hours are same, compare minutes
    return t1Parts[1].compareTo(t2Parts[1]);
  }
}

class SpeakerTile extends StatelessWidget {
  const SpeakerTile({
    required this.tileColor,
    required this.name,
    required this.time,
    required this.speakerId,
    required this.eventId,
    required this.questionCount,
    required this.onTap,
    required this.trailingIcon,
    this.pendingQuestions = 0,
    super.key,
  });
  final String name;
  final String time;
  final String speakerId;
  final int eventId;
  final int questionCount;
  final int pendingQuestions;
  final VoidCallback onTap;
  final Widget trailingIcon;
  final Color tileColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Speaker icon (circle with face)
            Center(
              child: Assets.icons.messageIcon.svg(),
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
            trailingIcon,
          ],
        ),
      ),
    );
  }
}
