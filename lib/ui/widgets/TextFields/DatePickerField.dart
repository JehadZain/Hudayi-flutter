import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/AppColors.dart';
import 'package:hudayi/ui/helper/AppFunctions.dart';
import 'package:hudayi/ui/widgets/textfield_container.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final String? intialValue;
  final void Function() onTap;
  final bool readOnly;
  final void Function(String?)? onChanged;
  const DatePickerField(
      {super.key, this.controller, this.intialValue, required this.title, this.onChanged, required this.onTap, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    controller!.selection = TextSelection.collapsed(offset: controller!.text.length);

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
      validateMode: readOnly ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
      validator: (String? value) {
        if (value!.isEmpty) {
          return translate(context).fieldNotEmptyError;
        }
        return null;
      },
      keyboardType: TextInputType.name,
      onChanged: onChanged ?? (_) {},
    );
  }
}

selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 30850)),
    lastDate: DateTime.now(),
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor, // button , // <-- SEE HERE
          ),
          textButtonTheme: const TextButtonThemeData(),
        ),
        child: child!,
      );
    },
  );
  if (picked != null) {
    return picked.toString().substring(0, 10);
  }
}

selectTime(BuildContext context) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary, // button , // <-- SEE HERE
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    return picked.format(context).replaceAll("ص", "").replaceAll("م", "")
        .replaceAll("am", "")
        .replaceAll("pm", "");
  }
}
