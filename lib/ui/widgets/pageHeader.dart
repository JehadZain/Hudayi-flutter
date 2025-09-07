import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hudayi/screens/home.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppConstants.dart';
import 'package:hudayi/ui/helper/AppConsts.dart';
import 'package:hudayi/ui/helper/AppDialog.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:image_picker/image_picker.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final XFile path;
  final bool isCircle;
  final String? checkedValue;
  final bool? isBacked;
  final Function()? uploadTap;
  const PageHeader({Key? key, required this.path, required this.title, required this.isCircle, this.uploadTap, this.checkedValue, this.isBacked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)), color: AppColors.primary),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 17.0),
              child: Row(
                mainAxisAlignment: isBacked != false ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isBacked != false)
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(19), bottomEnd: Radius.circular(19))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.arrow_back_ios_rounded,
                                color: AppColors.primary,
                              ),
                              onTap: () {
                                if (checkedValue != "noDialog") {
                                  showCustomDialog(context, translate(context).leave_page_confirmation, AppConstants.appLogo, "exit", () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Center(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  if (isBacked != false)
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(19), bottomStart: Radius.circular(19))),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 8, end: 16, start: 16, bottom: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: const Icon(
                                Icons.home,
                                color: AppColors.primary,
                              ),
                              onTap: () {
                                Navigator.of(context).pushAndRemoveUntil(createRoute(const HomeScreen()), (Route<dynamic> route) => false);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isCircle)
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: GestureDetector(
                    onTap: uploadTap ?? () {},
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: path.path != ""
                          ? FileImage(
                              File(path.path.toString()),
                            )
                          : null,
                      child: path.path != ""
                          ? null
                          : const Icon(
                              Icons.upload,
                              color: Colors.black,
                              size: 35,
                            ),
                    )),
              ),
          ],
        ),
      ),
    );
  }
}
