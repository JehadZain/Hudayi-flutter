import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/App_Colors.dart';
import 'package:hudayi/ui/styles/app_Box_Shadow.dart';
import 'package:hudayi/ui/widgets/anmiation_card.dart';

class AddContainer extends StatelessWidget {
  final Widget page;
  final String text;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;
  final bool? isArrow;
  final Function() onTap;
  const AddContainer(
      {Key? key,
      required this.page,
      required this.text,
      this.isArrow,
      this.color,
      this.textColor,
      this.boxShadow,
      this.borderColor,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return page.toString() == "Container"
        ? GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
              child: Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: boxShadow ?? [AppBoxShadow.containerBoxShadow],
                  ),
                  child: Center(
                    child: isArrow == null
                        ? Text(
                            text,
                            style: TextStyle(color: textColor ?? Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  text,
                                  style: TextStyle(color: textColor ?? Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                  )),
            ),
          )
        : AnmiationCard(
            onTap: onTap,
            page: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 0, bottom: 4),
              child: Container(
                  height: 85,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: boxShadow ?? [AppBoxShadow.containerBoxShadow],
                  ),
                  child: Center(
                    child: isArrow == null
                        ? Text(
                            text,
                            style: TextStyle(color: textColor ?? Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: textColor ?? Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                  )),
            ),
            displayedPage: page,
          );
  }
}
