import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hudayi/ui/helper/app_colors.dart';

class TextFieldContainer extends StatefulWidget {
  final Decoration? containerDecoration;
  final Widget? child;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String hintText;
  final String? asssetPath;
  final GlobalKey<FormState>? formkey;
  final bool? obscureText;
  final String errorMsg;
  final String? labelText;

  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? presuffixIcon;
  final Color? fillcolor;
  final double? width;
  final double? height;
  final int? maxLines;
  final int? minLines;
  final bool? focusedBorder;
  final bool? border;
  final bool enabledBorder;
  final bool autofocus;
  final TextEditingController? controller;
  final Color? hintTextColor;
  final double? hintTextSize;
  final String? initialValue;
  final double? texthintbottomPadding;
  final double? texthintleftPadding;
  final Color? cursorColor;
  final void Function()? onEditingComplete;
  final void Function()? onTap;
  final bool? enabled;
  final bool? readOnly;
  final InputDecoration? decoration;
  final AutovalidateMode? validateMode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  const TextFieldContainer(
      {Key? key,
      this.child,
      this.height,
      this.width,
      this.onChanged,
      this.keyboardType,
      this.initialValue,
      this.textInputAction,
      required this.hintText,
      this.labelText,
      this.asssetPath,
      this.minLines,
      this.maxLines,
      this.formkey,
      this.presuffixIcon,
      required this.errorMsg,
      this.obscureText,
      this.validateMode,
      this.validator,
      this.controller,
      this.fillcolor,
      this.inputFormatters,
      this.suffixIcon,
      this.focusedBorder = true,
      this.border = true,
      this.enabledBorder = true,
      this.enabled = true,
      this.readOnly = false,
      this.onTap,
      this.texthintbottomPadding,
      this.hintTextColor,
      this.hintTextSize,
      this.onEditingComplete,
      this.texthintleftPadding,
      this.cursorColor,
      this.decoration,
      this.autofocus = false,
      this.containerDecoration})
      : super(key: key);
  @override
  _TextFieldContainerState createState() => _TextFieldContainerState(child);
}

class _TextFieldContainerState extends State<TextFieldContainer> {
  final Widget? child;

  _TextFieldContainerState(this.child);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Container(
        decoration: widget.containerDecoration,
        width: widget.width == null ? screenWidth : screenWidth * widget.width!,
        height: widget.height == null ? null : screenHeight * widget.height!,
        child: TextFormField(
          autovalidateMode: widget.validateMode,
          autofocus: widget.autofocus,
          inputFormatters: widget.inputFormatters ?? [],
          cursorColor: widget.cursorColor ?? Colors.black,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onChanged: widget.onChanged,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          enabled: widget.enabled,
          initialValue: widget.initialValue,
          controller: widget.controller,
          readOnly: widget.readOnly!,
          obscureText: widget.obscureText == null ? false : widget.obscureText!,
          decoration: buildInputDecoration(
              hinttext: widget.hintText,
              suffixIcon: widget.suffixIcon,
              labelText: widget.labelText,
              assetPath: widget.asssetPath,
              presuffixIcon: widget.presuffixIcon,
              fillcolor: widget.fillcolor,
              color: widget.hintTextColor == null ? Colors.black : widget.hintTextColor!,
              bottom: widget.texthintbottomPadding == null ? 0.0 : widget.texthintbottomPadding!,
              left: widget.texthintleftPadding == null ? 0.0 : widget.texthintleftPadding!,
              border: widget.border,
              enabledBorder: widget.enabledBorder,
              focusedBorder: widget.focusedBorder,
              fontsize: widget.hintTextSize == null ? 14 : widget.hintTextSize!,
              imageColor: AppColors.primary),
          validator: widget.validator,
          onTap: widget.onTap,
          // onEditingComplete: widget.onEditingComplete ??
          //     () {
          //       FocusScope.of(context).requestFocus(FocusNode());
          //       if (widget.formkey!.currentState!.validate()) {
          //         return;
          //       } else {
          //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //           content: Text(widget.errorMsg,
          //               style: const TextStyle(fontFamily: getFontName(context))),
          //         ));
          //       }
          //     }
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration({
  required String hinttext,
  String? labelText,
  String? assetPath,
  required Color color,
  required double fontsize,
  required Color imageColor,
  Color? fillcolor,
  Widget? suffixIcon,
  Widget? presuffixIcon,
  bool? focusedBorder = true,
  bool? border = true,
  bool enabledBorder = true,
  double bottom = 0.0,
  double left = 0.0,
}) {
  return InputDecoration(
      hintText: hinttext,
      isDense: true,
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
      prefixIcon: assetPath == null
          ? presuffixIcon
          : Image.asset(
              assetPath,
              height: 17,
              width: 17,
              color: imageColor,
            ),
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(fontSize: fontsize, color: color),
      labelText: labelText,
      labelStyle: TextStyle(fontSize: fontsize, color: color),
      contentPadding: const EdgeInsets.all(8),
      fillColor: fillcolor ?? const Color(0xFFEEEEEE),
      filled: true,
      focusedBorder: focusedBorder == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            )
          : InputBorder.none,
      border: border == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            )
          : InputBorder.none,
      enabledBorder: enabledBorder == true
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color.fromARGB(100, 158, 158, 158)),
            )
          : InputBorder.none);
}
//,
