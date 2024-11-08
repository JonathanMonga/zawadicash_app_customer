// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:zawadicash_app/helper/functions.dart';
import 'package:zawadicash_app/util/color_resources.dart';
import 'package:zawadicash_app/util/dimensions.dart';

class CustomPasswordField extends StatefulWidget {
  final bool? isShowSuffixIcon;
  final bool? isPassword;
  final bool? isIcon;
  final OnPressedFunction? onSuffixTap;
  final String? suffixIconUrl;
  final String? hint;
  final TextAlign? textAlign;
  final TextEditingController? controller;
  final double? fontSize, letterSpacing;
  final FocusNode? nextFocus, focusNode;
  final TextInputAction? textInputAction;

  const CustomPasswordField({
    super.key,
    this.isShowSuffixIcon,
    this.isPassword,
    this.isIcon = false,
    this.onSuffixTap,
    this.suffixIconUrl,
    this.hint,
    this.textAlign = TextAlign.start,
    this.controller,
    this.fontSize = 17.0,
    this.letterSpacing = 2.0,
    this.focusNode,
    this.nextFocus,
    this.textInputAction = TextInputAction.next,
  });

  @override
  _CustomPasswordFieldState createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword! ? _obscureText : false,
      cursorColor: Theme.of(context).textTheme.titleLarge!.color,
      textAlign: widget.textAlign!,
      keyboardType: TextInputType.number,
      textInputAction: widget.textInputAction,
      maxLength: 4,
      onSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge!.color,
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w500,
        letterSpacing: widget.letterSpacing,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 22),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
          borderSide: BorderSide(
            color: Theme.of(context).textTheme.titleLarge!.color!,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SIZE_SMALL),
          borderSide: BorderSide(
            color: ColorResources.textFieldBorderColor,
            width: 1,
          ),
        ),
        hintText: widget.hint,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          letterSpacing: 1.5,
        ),
        suffixIcon: widget.isShowSuffixIcon!
            ? widget.isPassword!
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                      size: 18,
                    ),
                    onPressed: _toggle)
                : widget.isIcon!
                    ? IconButton(
                        onPressed: widget.onSuffixTap!,
                        icon: Image.asset(
                          widget.suffixIconUrl!,
                          width: 15,
                          height: 15,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                      )
                    : null
            : null,
      ),
    );
  }

  void _toggle() {
    debugPrint('off');
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
