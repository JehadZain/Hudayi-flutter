import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/helper/App_Icons.dart';
import 'package:hudayi/ui/helper/App_Text_Styles.dart';
import 'package:hudayi/ui/widgets/glowing_stars.dart';
import 'package:flutter/material.dart';

class AnimatedHeader extends StatefulWidget {
  const AnimatedHeader({super.key, this.isWriting, this.focusNode, required this.height, required this.text});

  final FocusNode? focusNode;
  final bool? isWriting;
  final double height;
  final String text;
  @override
  _AnimatedHeaderState createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<AnimatedHeader> {
  @override
  bool get wantKeepAlive => true;
  late Animation<Offset> _topCloudAnim;
  late Animation<Offset> _bottomCloudAnim;
  late AnimationController cloudController;

  @override
  void initState() {
    _setupCloudAnimation();

    super.initState();
  }

  @override
  void dispose() {
    cloudController.dispose();
    super.dispose();
  }

  _setupCloudAnimation() {
    cloudController = AnimationController(duration: const Duration(seconds: 15), vsync: this)
      ..forward()
      ..reverse()
      ..repeat();

    _topCloudAnim = Tween<Offset>(begin: const Offset(3.0, 0.0), end: const Offset(-5.5, 0.0)).animate(cloudController);
    _bottomCloudAnim = Tween<Offset>(begin: const Offset(-5.5, 0.0), end: const Offset(3.0, 0.0)).animate(cloudController);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnimatedSize(
      curve: Curves.easeInOutCirc,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: widget.height,
        decoration: widget.height != 50
            ? BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(!AppFunctions().isValidTimeRange(const TimeOfDay(hour: 06, minute: 00), const TimeOfDay(hour: 18, minute: 00))
                      ? AppIcons.homeHeader
                      : AppIcons.homeHeaderLight),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              )
            : BoxDecoration(
                color: AppFunctions().isValidTimeRange(const TimeOfDay(hour: 06, minute: 00), const TimeOfDay(hour: 18, minute: 00))
                    ? AppColors.primary
                    : Colors.black,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12), bottomLeft: Radius.circular(12))),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (Theme.of(context).brightness == Brightness.light)
              Positioned(
                top: 70,
                child: SafeArea(
                  child: SlideTransition(
                    position: _bottomCloudAnim,
                    child: Image.asset(AppIcons.cloudBottom, width: 100),
                  ),
                ),
              ),
            if (Theme.of(context).brightness == Brightness.light)
              Positioned(
                top: 10,
                child: SafeArea(
                  child: SlideTransition(
                    position: _topCloudAnim,
                    child: Image.asset(AppIcons.cloutTop, width: 100),
                  ),
                ),
              ),
            if (!AppFunctions().isValidTimeRange(const TimeOfDay(hour: 06, minute: 00), const TimeOfDay(hour: 18, minute: 00)))
              const Align(
                alignment: Alignment.center,
                child: GlowingStars(),
              ),
            Text(
              widget.text,
              style: AppTextStyles.headLine1,
            ),
          ],
        ),
      ),
    );
  }
}
