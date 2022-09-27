import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saturn/saturn.dart';
import 'package:saturn_login/page/area_code_page.dart';
import 'package:saturn_login/page/find_password_page.dart';
import 'package:saturn_login/utils/area_code_constant.dart';
import 'package:saturn_login/utils/callbacks.dart';
import 'package:saturn_login/utils/config.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/utils/verified_mobile.dart';
import 'package:saturn_login/widgets/mobile_input.dart';
import 'package:saturn_routers/sc_routers.dart';

class SCPasswordLogin extends StatefulWidget {
  const SCPasswordLogin({Key? key, this.switchVerifyCodeTap}) : super(key: key);

  final SCBoolCallback? switchVerifyCodeTap;

  @override
  State<SCPasswordLogin> createState() => _SCPasswordLoginState();
}

class _SCPasswordLoginState extends State<SCPasswordLogin> {
  var _selectedArea = {"中国": "86"};
  final TextEditingController _mobileCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  late ValueNotifier<bool> _btnNotifier;
  late ValueNotifier<bool> _btnDisabledNoti;
  int _limitLength = 11;
  final FocusNode _mobileNode = FocusNode(debugLabel: 'mobile');
  final FocusNode _passwordNode = FocusNode(debugLabel: 'password');

  @override
  void initState() {
    super.initState();
    _btnNotifier = ValueNotifier(false);
    _btnDisabledNoti = ValueNotifier(true);
    _mobileCon.addListener(() {
      if (_mobileCon.text.length > 7 && _passwordCon.text.isNotEmpty) {
        _btnDisabledNoti.value = false;
      } else {
        _btnDisabledNoti.value = true;
      }
    });

    _passwordCon.addListener(() {
      if (_mobileCon.text.length > 7 && _passwordCon.text.isNotEmpty) {
        _btnDisabledNoti.value = false;
      } else {
        _btnDisabledNoti.value = true;
      }
    });
  }

  @override
  void dispose() {
    _mobileCon.dispose();
    _passwordCon.dispose();
    _btnNotifier.dispose();
    _btnDisabledNoti.dispose();
    _mobileNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildTitle(),
          Padding(
            padding: const EdgeInsets.only(bottom: SCLoginConstant.spaceFix36),
            child: _buildForm(),
          ),
          ValueListenableBuilder(
            valueListenable: _btnNotifier,
            builder: (context, bool loading, child) {
              return ValueListenableBuilder(
                  valueListenable: _btnDisabledNoti,
                  builder: (cnt, bool disabled, _) {
                    return STButton(
                      mainAxisSize: MainAxisSize.max,
                      text: '登录',
                      textStyle: SCTextStyleConst.btnFirTextStyle,
                      disabled: disabled,
                      loading: loading,
                      height: SCLoginConstant.loginBtnH,
                      onTap: () {
                        _requestHttp();
                      },
                    );
                  });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: SCLoginConstant.horFix16),
            child: STButton(
              text: '忘记密码',
              type: STButtonType.text,
              textStyle: SCTextStyleConst.btnSecTextStyle,
              onTap: () {
                SCRouters.push(context, const SCFindPasswordPage());
              },
            ),
          ),
        ],
      ),
    );
  }

  void _requestHttp() async {
    _btnNotifier.value = true;
    await SCConfig.instance().api.requestLogin(
          _mobileCon.text,
          password: _passwordCon.text,
        );
    _btnNotifier.value = false;
  }

  Widget _buildTitle() {
    return Container(
      padding: const EdgeInsets.only(
        top: SCLoginConstant.topFix,
        bottom: SCLoginConstant.spaceFix44,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '手机密码登录',
            style: SCConfig.instance()
                .getTextStyle(SCConfigConstant.titleFirTextStyle),
          ),
          STButton(
            type: STButtonType.text,
            text: '验证码登录',
            onTap: () {
              if (widget.switchVerifyCodeTap == null) return;
              widget.switchVerifyCodeTap!(false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        SCMobileInput(
          areaStr: _selectedArea.values.first,
          controller: _mobileCon,
          focusNode: _mobileNode,
          mobileLength: _limitLength,
          onTap: () {
            final areaCodePage = SCAreaCodePage(
              onChanged: (Map<String, String> selected) {
                _switchAreaCode(selected);
              },
            );
            SCRouters.push(
              context,
              areaCodePage,
              direction: SCRoutersDirection.bottomToTop,
            );
          },
          onChanged: (String value) {
            if (value.length == _limitLength) {
              if (!_verifyMobile(value)) return;
              Future.delayed(const Duration(milliseconds: 50), () {
                FocusScope.of(context).requestFocus(_passwordNode);
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: SCLoginConstant.horFix16),
          child: STInput.password(
            key: const Key('password'),
            controller: _passwordCon,
            textStyle: SCTextStyleConst.inputTextStyle,
            backgoundColor: SCColorConst.inputBgColor,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
            ],
            focusNode: _passwordNode,
            onSubmitted: (String value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        ),
      ],
    );
  }

  Future _switchAreaCode(Map<String, String> selected) async {
    _selectedArea = selected;
    final selectedKey = _selectedArea.keys.first;
    const temps = SCAreaCodeConstant.worldCodeLengths;
    if (temps[selectedKey] != null) {
      _limitLength = int.tryParse(temps[selectedKey]!) ?? 11;
    }
    setState(() {});
  }

  bool _verifyMobile(String value) {
    if (!SCVerifiedMobile.verifyMobile(
      value: value,
      area: _selectedArea.values.first,
    )) {
      STToast.show(context: context, message: '手机号输入错误');
      return false;
    }
    return true;
  }
}
