import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    required this.largeScreen,
    super.key,
    this.mediumScreen,
    this.smallScreen,
  });
  final Widget largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 1025;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1025;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 800 &&
        MediaQuery.sizeOf(context).width <= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 800) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
