import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moveme/theme.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final FocusNode nextFocus;
  final String label;
  final TextInputType keyBoardType;
  final bool obscureText;
  final TextAlign textAlign;
  final bool enabled;
  final TextInputAction action;
  final int maxLength;
  final TextCapitalization capitalization;
  final Widget suffix;
  final VoidCallback onSubmitted;
  final bool isDecorationDefault;

  TextFieldCustom(
      {@required this.controller,
      @required this.label,
      this.focus,
      this.nextFocus,
      this.action = TextInputAction.next,
      this.keyBoardType = TextInputType.text,
      this.textAlign = TextAlign.left,
      this.obscureText = false,
      this.maxLength,
      this.suffix,
      this.onSubmitted,
      this.capitalization = TextCapitalization.sentences,
      this.enabled = true,
      this.isDecorationDefault = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        focusNode: focus,
        enableSuggestions: false,
        enableInteractiveSelection: false,
        onSubmitted: (String a) {
          if (onSubmitted != null) onSubmitted();
          if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
        },
        style:
            this.isDecorationDefault ? AppTextStyle.textBlueLightExtraSmall : TextStyle(fontSize: AppSizes.fontMedium),
        keyboardType: keyBoardType,
        textInputAction: action,
        textAlign: textAlign,
        enabled: enabled,
        inputFormatters: maxLength == null ? [] : [LengthLimitingTextInputFormatter(maxLength)],
        obscureText: obscureText,
        textCapitalization: capitalization,
        decoration: getDecoration());
  }

  InputDecoration getDecoration() {
    if (this.isDecorationDefault) {
      return InputDecoration(
        contentPadding: AppSizes.inputPadding,
        labelText: label,
        suffixIcon: suffix,
        labelStyle: AppTextStyle.textBlueLightExtraSmall,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.colorBlueLight, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(25))),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.colorBlueLight, width: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(18))),
      );
    } else {
      return InputDecoration(
          hintText: label,
          suffixIcon: suffix,
          fillColor: AppColors.colorGrey.withOpacity(0.2),
          filled: true,
          hintStyle: TextStyle(fontSize: AppSizes.fontMedium),
          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: AppColors.colorGrey)));
    }
  }
}
