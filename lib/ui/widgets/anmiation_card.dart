import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnmiationCard extends StatelessWidget {
  const AnmiationCard({
    Key? key,
    required this.page,
    required this.displayedPage,
    this.closedElevation,
    this.onTap,
  }) : super(key: key);
  final Widget page;
  final double? closedElevation;
  final Widget displayedPage;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext _, VoidCallback openContainer) {
        return displayedPage;
      },
      openShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      tappable: false,
      closedColor: Colors.transparent,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      closedElevation: closedElevation ?? 0.0,
      openElevation: 0.0,
      transitionDuration: const Duration(milliseconds: 600),
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return GestureDetector(
            onTap: () {
              openContainer();
              if (onTap != null) onTap!();
            },
            child: page);
      },
    );
  }
}
