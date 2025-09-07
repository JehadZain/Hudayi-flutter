import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hudayi/models/Languageprovider.dart';
import 'package:hudayi/screens/add/add.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/helper.dart';

showCustomDialog(BuildContext context, String title, String image, String type, Function()? yesOnTap, {bool? barrierDismissible, Function()? noOnTap}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: barrierDismissible == null ? true : false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (_, __, ___) {
      return WillPopScope(
        onWillPop: () async => barrierDismissible == null ? true : false,
        child: Center(
          child: Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Helper.sizedBoxW20,
                    Image.asset(
                      image,
                      height: 50,
                      width: 50,
                    ),
                    Helper.sizedBoxW10,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DefaultTextStyle(
                          style: const TextStyle(fontSize: 17, wordSpacing: 0, letterSpacing: 0, color: Colors.black, fontWeight: FontWeight.normal),
                          child: Text(
                            title,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (type == "delete") {
                          showLoadingDialog(context);
                          String status = await yesOnTap!.call();
                          FocusManager.instance.primaryFocus?.unfocus();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop(status);
                          if (status == "SUCCESS") {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text(translate(context).operationCompletedSuccessfully, style:  TextStyle(fontFamily: getFontName(context))),
                              duration: const Duration(milliseconds: 500),
                            ));
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop(status);
                          } else if (status == "FAILED") {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(translate(context).unexpected_error, style:  TextStyle(fontFamily: getFontName(context))),
                              duration: const Duration(seconds: 1),
                            ));
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop(status);
                          }
                        } else {
                          yesOnTap!.call();
                        }
                      },
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 18, color: AppColors.primary, fontWeight: FontWeight.normal),
                        child: Text(
                          type == "refresh" ? translate(Get.context!).contactSupervisor : translate(Get.context!).yes,
                        ),
                      ),
                    ),
                      if(type != "refresh" || noOnTap !=null) Helper.sizedBoxW80,
                      if (type != "refresh" || noOnTap != null)
                      GestureDetector(
                        onTap: noOnTap?? () {
                          Navigator.of(context).pop("doNotExit");
                        },
                        child: DefaultTextStyle(
                          style: TextStyle(fontSize: 18, color: type == "refresh"? AppColors.primary : Colors.red, fontWeight: FontWeight.normal),
                          child: Text(
                            type == "refresh"?translate(Get.context!).downloadTheApp:translate(Get.context!).no,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      Tween<Offset> tween;
      if (anim.status == AnimationStatus.reverse) {
        tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
      } else {
        tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
      }

      return SlideTransition(
        position: tween.animate(anim),
        child: FadeTransition(
          opacity: anim,
          child: child,
        ),
      );
    },
  );
}
