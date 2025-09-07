import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/dropDownBottomSheet.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class OneSelectionField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? intialValue;
  final void Function() onTap;
  final void Function(String?)? onChanged;
  final bool readOnly;
  final bool isRequired;
  const OneSelectionField(
      {super.key,
      required this.controller,
      this.intialValue,
      required this.title,
      this.onChanged,
      required this.onTap,
      required this.readOnly,
      required this.isRequired});

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.collapsed(offset: controller.text.length);

    return TextFieldContainer(
      controller: controller,
      initialValue: intialValue,
      labelText: title,
      readOnly: true,
      hintText: "",
      hintTextSize: 18,
      onTap: readOnly == true ? () {} : onTap,
      hintTextColor: Colors.grey,
      fillcolor: Colors.white,
      errorMsg: "",
      validator: isRequired
          ? (String? value) {
              if (value!.isEmpty) {
                return translate(context).fieldNotEmptyError;
              }
              return null;
            }
          : (String? value) {
              return null;
            },
      validateMode: readOnly ? AutovalidateMode.disabled : AutovalidateMode.always,
      onChanged: onChanged ?? (_) {},
    );
  }
}
