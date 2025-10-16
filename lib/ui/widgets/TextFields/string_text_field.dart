import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class StringTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? intialValue;
  final bool readOnly;
  final bool isRequired;
  final bool? obscureText;
  final void Function(String?)? onChanged;
  const StringTextField(
      {super.key,
      required this.controller,
      this.intialValue,
      required this.title,
      this.onChanged,
      required this.readOnly,
      required this.isRequired,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      return value!.isEmpty
          ? null
          : !regex.hasMatch(value)
              ? translate(context).validEmailAddress
              : null;
    }

    String? validateUsername(String? value) {
      if (value == null || value.isEmpty) {
        return translate(context).fieldNotEmptyError;
      }

      final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');

      if (!usernameRegex.hasMatch(value)) {
        return translate(context).usernameRestriction;
      }

      return null;
    }

    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return TextFieldContainer(
      controller: controller,
      initialValue: intialValue,
      labelText: title,
      readOnly: readOnly,
      maxLines: 1,
      obscureText: obscureText == null ? false : true,
      hintText: "",
      hintTextSize: 15,
      onTap: () {
        if (controller.selection ==
            TextSelection.fromPosition(
                TextPosition(offset: controller.text.length - 1))) {
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.text.length));
        }
      },
      hintTextColor: Colors.grey,
      fillcolor: Colors.white,
      errorMsg: "",
      validator: isRequired
          ? title == translate(context).username
              ? validateUsername
              : title == translate(context).email_address
                  ? validateEmail
                  : (String? value) {
                      if (value!.isEmpty) {
                        return translate(context).fieldNotEmptyError;
                      }
                      return null;
                    }
          : title == translate(context).email_address
              ? validateEmail
              : (String? value) {
                  return null;
                },
      keyboardType: TextInputType.name,
      validateMode: readOnly
          ? AutovalidateMode.disabled
          : AutovalidateMode.onUserInteraction,
      onChanged: onChanged ??
          (_) {
            if (controller.selection ==
                TextSelection.fromPosition(
                    TextPosition(offset: controller.text.length - 1))) {
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
            }
          },
    );
  }
}
