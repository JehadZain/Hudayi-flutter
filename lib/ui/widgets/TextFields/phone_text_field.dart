import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hudayi/ui/helper/App_Functions.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String? intialValue;
  final bool readOnly;
  final bool isRequired;
  final Function(PhoneNumber)? onChanged;
  const PhoneTextField({
    super.key,
    required this.controller,
    this.intialValue,
    required this.title,
    this.onChanged,
    required this.readOnly,
    required this.isRequired,
  });

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  PhoneNumber number = PhoneNumber(isoCode: Platform.localeName.split('_').last);
  @override
  void initState() {
    () async {
      String value = await AppFunctions().getCountryCodeFromNumber(widget.controller.text);
      String code = await AppFunctions().getCountryCode(widget.controller.text);
      if (value != "") {
        widget.controller.text = widget.controller.text.replaceAll("+$value", " ");
        number = PhoneNumber(isoCode: code, phoneNumber: widget.controller.text.replaceAll("+$value", " "), dialCode: value);
        setState(() {});
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color.fromARGB(100, 158, 158, 158),
              width: 1,
            )),
        child: Directionality(
          textDirection: translate(context).localeName == "ar" ? TextDirection.rtl : TextDirection.ltr,
          child: InternationalPhoneNumberInput(
            onInputChanged: widget.onChanged ?? (_) {},
            cursorColor: Colors.black,
            textAlign: TextAlign.right,
            searchBoxDecoration: InputDecoration(labelText: translate(context).searchForCountry),
            selectorConfig: const SelectorConfig(selectorType: PhoneInputSelectorType.BOTTOM_SHEET, leadingPadding: 5, trailingSpace: false),
            ignoreBlank: false,
            selectorButtonOnErrorPadding: 35,
            hintText: widget.title,
            isEnabled: !widget.readOnly,
            errorMessage: translate(context).validPhoneNumber,
            locale: "ar",
            textFieldController: widget.controller,
            autoValidateMode: widget.isRequired
                ? widget.readOnly
                    ? AutovalidateMode.disabled
                    : AutovalidateMode.always
                : AutovalidateMode.always,
            validator: widget.isRequired && widget.controller.text == ""
                ? null
                : (String? value) {
                    return null;
                  },
            selectorTextStyle: const TextStyle(color: Colors.black),
            initialValue: number,
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
            inputBorder: InputBorder.none,
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
        ),
      ),
    );
  }
}
