import 'package:flutter/material.dart';
import 'package:hudayi/main.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/helper/App_Consts.dart';
import 'package:hudayi/ui/widgets/helper.dart';

class ActionBar extends StatelessWidget {
  final List menuseItem;
  final Color? containerColor;
  const ActionBar({Key? key, required this.menuseItem, this.containerColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                  valueListenable: isMenueOpended,
                  builder: (context, value, widget) {
                    return AnimatedCrossFade(
                        firstChild: Container(
                          decoration: BoxDecoration(
                              color: containerColor == null ? AppColors.primary : Colors.white,
                              borderRadius: const BorderRadiusDirectional.only(bottomEnd: Radius.circular(19), topEnd: Radius.circular(19))),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: containerColor == null ? Colors.white : AppColors.primary,
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                const SizedBox(width: 5),
                                if (menuseItem.isNotEmpty)
                                  GestureDetector(
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: containerColor == null ? Colors.white : AppColors.primary,
                                    ),
                                    onTap: () {
                                      isMenueOpended.value = true;
                                      Future.delayed(const Duration(seconds: 1), () {
                                        isMenueOpended.value = false;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        secondChild: Container(
                          width: value ? 145 : 50,
                          decoration: BoxDecoration(
                            color: containerColor == null ? AppColors.primary : Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                          ),
                          child: !value
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (Map i in menuseItem)
                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 12, 4),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (i["onTap"] != null) {
                                                i["onTap"].call();
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(color: const Color(0XFFE6F5ED), borderRadius: BorderRadius.circular(14)),
                                              child: Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      i["icon"],
                                                      color: Theme.of(context).primaryColor,
                                                    ),
                                                    Helper.sizedBoxW5,
                                                    Text(
                                                      i["title"],
                                                      style: const TextStyle(
                                                        color: Color(0xFF101213),
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                        crossFadeState: !value ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 50));
                  }),
              Container(
                decoration: BoxDecoration(
                    color: containerColor == null ? AppColors.primary : Colors.white,
                    borderRadius: const BorderRadiusDirectional.only(bottomStart: Radius.circular(19), topStart: Radius.circular(19))),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 8, end: 16, start: 16, bottom: 8),
                        child: Icon(
                          Icons.home,
                          color: containerColor == null ? Colors.white : AppColors.primary,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(createRoute(const HomeScreen()), (Route<dynamic> route) => false);
                      },
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
