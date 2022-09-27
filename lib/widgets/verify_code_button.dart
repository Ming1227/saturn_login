import 'dart:async';

import 'package:flutter/material.dart';

import 'package:saturn/saturn.dart';
import 'package:saturn_login/utils/config.dart';
import 'package:saturn_login/utils/login_constant.dart';

class SCVerifyCodeButton extends StatefulWidget {
  const SCVerifyCodeButton({
    Key? key,
    required this.baseStr,
    this.mobile = '',
    this.countDownStr = '秒后重发',
    this.style,
    this.countDown = 30,
  }) : super(key: key);

  final String baseStr;
  final String countDownStr;
  final TextStyle? style;
  final int countDown;
  final String mobile;

  @override
  State<SCVerifyCodeButton> createState() => _SCVerifyCodeButtonState();
}

class _SCVerifyCodeButtonState extends State<SCVerifyCodeButton> {
  late ValueNotifier<String> _btnValueNoti;
  late ValueNotifier<bool> _btnDisableNoti;
  Timer? _timer;
  int _currentTime = 0;
  late TextStyle _textStyle;

  @override
  void initState() {
    super.initState();
    _btnValueNoti = ValueNotifier(widget.baseStr);
    _btnDisableNoti = ValueNotifier(false);
    _currentTime = widget.countDown;
    _textStyle = widget.style ?? SCTextStyleConst.titleFourTextStyle;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _btnValueNoti.dispose();
    _btnDisableNoti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _btnValueNoti,
      builder: (context, String value, child) {
        return ValueListenableBuilder(
            valueListenable: _btnDisableNoti,
            builder: (cnt, bool disabled, _) {
              return STButton(
                text: value,
                textStyle: _textStyle,
                disabled: disabled,
                onTap: _getCheckCode,
              );
            });
      },
    );
  }

  _getCheckCode() async {
    if (widget.mobile.isNotEmpty) {
      final mobile = widget.mobile.replaceAll(" ", "");
      // // 请求接口
      final result = await SCConfig.instance().api.requestVerifyCode(mobile);
      if (result.success) {
        STMessage.show(context: context, title: '验证码如下', message: '000000');
        _btnDisableNoti.value = !_btnDisableNoti.value;
        _startTimer();
      } else {
        STMessage.show(context: context, title: result.message);
      }
    } else {
      STMessage.show(context: context, title: '请输入手机号');
    }
  }

  /// 启动Timer计时
  void _startTimer() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentTime != 0) {
        _currentTime--;
        _btnValueNoti.value = _currentTime.toString() + widget.countDownStr;
      } else {
        /// 重置
        _btnValueNoti.value = widget.baseStr;
        _btnDisableNoti.value = !_btnDisableNoti.value;
        _timer?.cancel();
        _timer = null;
        _currentTime = widget.countDown;
      }
    });
  }
}
