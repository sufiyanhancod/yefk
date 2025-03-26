// import 'dart:ui';

// import 'package:app/gen/assets.gen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter/foundation.dart';
// import 'package:app/features/home/home.dart';
// import 'package:app/shared/shared.dart';
// import 'package:app/shared/widgets/qr_scanner/qr_scanner_view.dart';

// class HomeNavigationBar extends ConsumerStatefulWidget {
//   const HomeNavigationBar({
//     required this.navigationShell,
//     super.key,
//   });

//   final StatefulNavigationShell navigationShell;

//   @override
//   ConsumerState<HomeNavigationBar> createState() => _HomeNavigationBarState();
// }

// class _HomeNavigationBarState extends ConsumerState<HomeNavigationBar> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: widget.navigationShell,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         child: Stack(
//           children: [
//             Container(
//               height: 80,
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(40),
//                 // border: Border.all(
//                 //   color: Colors.white.withOpacity(0.2),
//                 //   width: 1.5,
//                 // ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.white.withOpacity(0.1),
//                     blurRadius: 15,
//                     spreadRadius: 5,
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(40),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 25, left: 10),
//                       child: _buildNavItem(
//                         icon: Icons.home_outlined,
//                         isSelected: widget.navigationShell.currentIndex == 0,
//                         onTap: () => widget.navigationShell.goBranch(0),
//                       ),
//                     ),
//                     const SizedBox(width: 24),
//                     GestureDetector(
//                       onTap: () => _scanQRCode(context),
//                       child: Assets.icons.scanQrcode.svg(
//                         width: 35,
//                         height: 35,
//                       ),
//                     ),
//                     const SizedBox(width: 24),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 25, right: 10),
//                       child: _buildNavItem(
//                         icon: Icons.access_time,
//                         isSelected: widget.navigationShell.currentIndex == 1,
//                         onTap: () => widget.navigationShell.goBranch(1),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isSelected ? Colors.amber : Colors.white,
//             size: 35,
//           ),
//           const SizedBox(height: 4),
//           Container(
//             width: 4,
//             height: 4,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isSelected ? Colors.amber : Colors.transparent,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _scanQRCode(BuildContext context) async {
//     try {
//       final eventsRepo = ref.read(eventsRepoProvider);
//       final userId = ref.read(supabaseProvider).auth.currentUser!.id;

//       final String? result = await Navigator.push<String>(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const QRScannerView(),
//         ),
//       );

//       if (result != null) {
//         await _processScannedSessionId(context, eventsRepo, userId, result);
//       }
//     } catch (e) {
//       Alert.showSnackBar('Error scanning QR code: ${e.toString()}');
//     }
//   }

//   Future<void> _processScannedSessionId(BuildContext context, IEventsRepository eventsRepo, String userId, String sessionId) async {
//     try {
//       final result = await eventsRepo.registerParticipation(userId, sessionId);
//       Alert.showSnackBar(result);
//     } catch (e) {
//       Alert.showSnackBar('Registration failed: ${e.toString()}');
//     }
//   }
// }
