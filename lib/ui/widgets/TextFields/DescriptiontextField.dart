import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String? intialValue;
  final bool readOnly;
  final void Function(String?)? onChanged;
  const DescriptionField({super.key, required this.controller, this.intialValue, required this.title, this.onChanged, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    controller.selection = TextSelection.collapsed(offset: controller.text.length);

    return TextFieldContainer(
      controller: controller,
      initialValue: intialValue,
      labelText: title,
      readOnly: readOnly,
      hintText: "",
      hintTextSize: 18,
      maxLines: null,
      onTap: () {
        if (controller.selection == TextSelection.fromPosition(TextPosition(offset: controller.text.length - 1))) {
          controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
        }
      },
      minLines: 6,
      textInputAction: TextInputAction.newline,
      hintTextColor: Colors.grey,
      fillcolor: Colors.white,
      errorMsg: "",
      validateMode: readOnly ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
      validator: (String? value) {
        if (value!.isEmpty) {
          return translate(context).fieldNotEmptyError;
        }
        return null;
      },
      keyboardType: TextInputType.multiline,
      onChanged: onChanged ?? (_) {},
    );
  }
}
