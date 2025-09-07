import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/helper/AppIcons.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    this.fabLocation = FloatingActionButtonLocation.centerDocked,
    this.shape = const CircularNotchedRectangle(),
    required this.currentIndex,
    required this.onTap,
  });

  final ValueNotifier<int> currentIndex;

  final ValueChanged<int>? onTap;
  final FloatingActionButtonLocation fabLocation;
  final NotchedShape? shape;
  static final List<FloatingActionButtonLocation> centerLocations = <FloatingActionButtonLocation>[
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.centerFloat,
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      showSelectedLabels: false,
      selectedFontSize: 0,
      unselectedFontSize: 0,
      onTap: (int index) {
        currentIndex.value = index;
        onTap!(index);
      },
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex.value,
      items: [
        BottomNavigationBarItem(
          icon: BottomItem(
            icon: AppIcons.rosary,
            text: translate(context).adhkar,
            currentIndex: currentIndex,
            index: 0,
            height: 40,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomItem(
            icon: AppIcons.quran,
            text: translate(context).quran,
            currentIndex: currentIndex,
            index: 1,
            height: 40,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomItem(
            text: '',
            currentIndex: currentIndex,
            index: 2,
            height: 40,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomItem(
            icon: AppIcons.branchLocation,
            text: translate(context).branches,
            currentIndex: currentIndex,
            index: 3,
            height: 60,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: BottomItem(
            icon: AppIcons.profile,
            text: translate(context).myFile,
            currentIndex: currentIndex,
            index: 4,
            height: 40,
          ),
          label: '',
        ),
      ],
    );
  }
}

class BottomItem extends StatefulWidget {
  const BottomItem({
    Key? key,
    required this.text,
    this.icon,
    required this.index,
    required this.currentIndex,
    required this.height,
  }) : super(key: key);

  final String text;
  final String? icon;
  final int index;
  final double height;
  final ValueNotifier<int> currentIndex;

  @override
  _BottomItemState createState() => _BottomItemState();
}

class _BottomItemState extends State<BottomItem> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<BottomItem> {
  @override
  bool get wantKeepAlive => true;
  late AnimationController controller;
  late Animation<Offset> textOffset1;
  late Animation<Offset> iconOffset1;

  double iconOffset = -0.1;
  double textOffset = 0.0;
  int duration = 1200;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: duration),
      reverseDuration: Duration(milliseconds: duration),
    );

    textOffset1 = Tween<Offset>(begin: Offset(0.0, textOffset), end: const Offset(0.0, 1.0)).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut, reverseCurve: Curves.elasticIn),
    );
    iconOffset1 = Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset(0.0, iconOffset)).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut, reverseCurve: Curves.elasticIn),
    );

    if (widget.currentIndex.value != widget.index) {
      controller.forward();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    widget.currentIndex.addListener(() {
      if (mounted) {
        if (widget.currentIndex.value == widget.index) {
          controller.reverse();
        } else {
          controller.forward();
        }
      }
    });
    return Tooltip(
      message: widget.text,
      child: SizedBox(
        height: widget.height,
        child: ClipPath(
          child: Stack(
            children: <Widget>[
              if (widget.icon != null)
                Align(
                  alignment: Alignment.center,
                  child: SlideTransition(
                    position: iconOffset1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Image.asset(
                        widget.icon!,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: SlideTransition(
                  position: textOffset1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.text,
                        style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppColors.primary,
                        ),
                        width: 3.5,
                        height: 3.5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
