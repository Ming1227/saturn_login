import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:saturn/saturn.dart';
import 'package:saturn_login/page/area_code_page.dart';
import 'package:saturn_login/utils/area_code_constant.dart';
import 'package:saturn_login/utils/callbacks.dart';
import 'package:saturn_login/utils/config.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/utils/verified_mobile.dart';
import 'package:saturn_login/widgets/mobile_input.dart';
import 'package:saturn_login/widgets/verify_code_button.dart';
import 'package:saturn_routers/sc_routers.dart';

class SCVerifyCodeLogin extends StatefulWidget {
  const SCVerifyCodeLogin({Key? key, this.switchPasswordTap}) : super(key: key);

  final SCBoolCallback? switchPasswordTap;

  @override
  State<SCVerifyCodeLogin> createState() => _SCVerifyCodeLoginState();
}

class _SCVerifyCodeLoginState extends State<SCVerifyCodeLogin> {
  var _selectedArea = {"中国": "86"};
  final TextEditingController _mobileCon = TextEditingController();
  final TextEditingController _codeCon = TextEditingController();
  late ValueNotifier<bool> _btnLoadingNoti;
  late ValueNotifier<bool> _btnDisableNoti;
  int _limitLength = 11;
  final FocusNode _mobileNode = FocusNode(debugLabel: 'mobile');
  final FocusNode _codeNode = FocusNode(debugLabel: 'code');

  @override
  void initState() {
    super.initState();
    _btnLoadingNoti = ValueNotifier(false);
    _btnDisableNoti = ValueNotifier(true);
    _mobileCon.addListener(() {
      if (_mobileCon.text.length > 7 && _codeCon.text.length == 6) {
        _btnDisableNoti.value = false;
      } else {
        _btnDisableNoti.value = true;
      }
    });
    _codeCon.addListener(() {
      if (_mobileCon.text.length > 7 && _codeCon.text.length == 6) {
        _btnDisableNoti.value = false;
      } else {
        _btnDisableNoti.value = true;
      }
    });
  }

  @override
  void dispose() {
    _mobileCon.dispose();
    _codeCon.dispose();
    _mobileNode.dispose();
    _codeNode.dispose();
    _btnLoadingNoti.dispose();
    _btnDisableNoti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: SCLoginConstant.topFix,
              bottom: SCLoginConstant.spaceFix24,
            ),
            child: _buildTitle(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: SCLoginConstant.spaceFix36),
            child: _buildForm(),
          ),
          ValueListenableBuilder(
            valueListenable: _btnLoadingNoti,
            builder: (context, bool loading, child) {
              return ValueListenableBuilder(
                  valueListenable: _btnDisableNoti,
                  builder: (cnt, bool disable, _) {
                    return STButton(
                      mainAxisSize: MainAxisSize.max,
                      text: '登录',
                      textStyle: SCTextStyleConst.btnFirTextStyle,
                      backgroundColor: SCConfig.instance()
                          .getColor(SCConfigConstant.firBlueColor),
                      disabled: disable,
                      loading: loading,
                      height: SCLoginConstant.loginBtnH,
                      onTap: () {
                        _requestHttp();
                      },
                    );
                  });
            },
          ),
        ],
      ),
    );
  }

  void _requestHttp() async {
    _btnLoadingNoti.value = true;
    await SCConfig.instance().api.requestLogin(
          _mobileCon.text,
          pin: _codeCon.text,
        );
    _btnLoadingNoti.value = false;
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '手机验证码登录',
              style: SCConfig.instance()
                  .getTextStyle(SCConfigConstant.titleFirTextStyle),
            ),
            STButton(
              type: STButtonType.text,
              text: '密码登录',
              onTap: () {
                /// 切换登陆方式
                if (widget.switchPasswordTap == null) return;
                widget.switchPasswordTap!(true);
              },
            ),
          ],
        ),
        Text(
          '首次登录即自动注册',
          style: SCConfig.instance()
              .getTextStyle(SCConfigConstant.btnThrTextStyle),
        ),
      ],
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
                FocusScope.of(context).requestFocus(_codeNode);
              });
            }
          },
        ),
        const SizedBox(height: SCLoginConstant.horFix16),
        STInput(
          key: const Key('code'),
          controller: _codeCon,
          focusNode: _codeNode,
          inputType: TextInputType.number,
          textStyle: SCTextStyleConst.inputTextStyle,
          backgoundColor: SCColorConst.inputBgColor,
          inputFormatters: [LengthLimitingTextInputFormatter(6)],
          suffixIcon: SCVerifyCodeButton(
            baseStr: '获取验证码',
            mobile: _mobileCon.text,
          ),
          placeholder: '输入验证码',
          onChanged: (value) {
            if (value.length == 6) {
              FocusScope.of(context).requestFocus(FocusNode());
            }
          },
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
