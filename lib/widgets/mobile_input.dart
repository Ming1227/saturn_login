import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:saturn/saturn.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/utils/mobile_input_formatter.dart';

class SCMobileInput extends StatelessWidget {
  const SCMobileInput({
    Key? key,
    required this.areaStr,
    required this.controller,
    required this.mobileLength,
    this.inputType = TextInputType.number,
    this.inputFormatters,
    this.placeholder,
    this.focusNode,
    this.inputTextStyle,
    this.inputBgColor,
    this.iconColor,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  final String areaStr;
  final int mobileLength;
  final TextEditingController controller;
  final TextInputType? inputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? placeholder;
  final FocusNode? focusNode;
  final TextStyle? inputTextStyle;
  final Color? inputBgColor;
  final Color? iconColor;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final focus = focusNode ?? FocusNode();
    final limitLength = _calculateLimitLength();
    final inputFors = inputFormatters ??
        [
          FilteringTextInputFormatter.allow(RegExp("[ |　]*([0-9])[ |　]*")),
          MobileInputFormatter(),
          LengthLimitingTextInputFormatter(limitLength),
        ];
    return STInput(
      backgoundColor: inputBgColor ?? SCColorConst.inputBgColor,
      textStyle: inputTextStyle ?? SCTextStyleConst.inputTextStyle,
      prefixIcon: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+$areaStr',
              style: inputTextStyle ?? SCTextStyleConst.inputTextStyle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Icon(
                Icons.arrow_drop_down,
                color: iconColor ?? Colors.black,
              ),
            ),
          ],
        ),
      ),
      placeholder: placeholder,
      controller: controller,
      inputType: inputType,
      inputFormatters: inputFors,
      focusNode: focus,
      onChanged: (String value) {
        if (onChanged != null) {
          onChanged!(_removeSpace(value));
        }
      },
    );
  }

  int _calculateLimitLength() {
    final temp = (mobileLength / 4.0).ceil();
    return mobileLength + temp;
  }

  String _removeSpace(String value) {
    return value.replaceAll(" ", "");
  }
}
