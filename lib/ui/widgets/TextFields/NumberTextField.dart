import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class NumberTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? intialValue;
  final bool readOnly;
  final bool isRequired;
  final void Function(String?)? onChanged;
  const NumberTextField({
    super.key,
    required this.controller,
    this.intialValue,
    required this.title,
    this.onChanged,
    required this.readOnly,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.collapsed(offset: controller.text.length);

    return Directionality(
      textDirection: translate(context).localeName=="ar"? TextDirection.rtl : TextDirection.ltr,
      child: TextFieldContainer(
        controller: controller,
        initialValue: intialValue,
        labelText: title,
        readOnly: readOnly,
        hintText: "",
        hintTextSize: 18,
        onTap: () {
          if (controller.selection == TextSelection.fromPosition(TextPosition(offset: controller.text.length - 1))) {
            controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
          }
        },
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
        inputFormatters: title.contains(translate(context).outOf10)
            ? [
                FilteringTextInputFormatter.allow(RegExp(r'^(10|[0-9])$')),
              ]
            : title.toString().toLowerCase().contains(translate(context).mark) || title.toString().toLowerCase().contains(translate(context).score)
                ? [
                    FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]?$|^100$')),
                  ]
                : [FilteringTextInputFormatter.allow(RegExp("[0-9+]"))],
        validateMode: readOnly ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
        keyboardType:
            title.contains(translate(context).phone) || title.contains(translate(context).phone) || title.contains(translate(context).whatsapp)
                ? TextInputType.phone
                : TextInputType.number,
        onChanged: onChanged ?? (_) {},
      ),
    );
  }
}
