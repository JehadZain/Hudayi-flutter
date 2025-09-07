import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';

class SaveButton extends StatelessWidget {
  final Function() onPressed;
  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
      child: GestureDetector(
          onTap: onPressed,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 41,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: AppColors.primary,
              ),

              // minWidth: double.infinity,
              //TODO:translate
              child:  Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Center(
                  child: Text(
                    translate(context).save,
                    style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ))),
    );
  }
}
