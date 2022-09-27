import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saturn/saturn.dart';
import 'package:saturn_login/page/area_code_page.dart';
import 'package:saturn_login/page/reset_password_page.dart';
import 'package:saturn_login/utils/area_code_constant.dart';
import 'package:saturn_login/utils/config.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/utils/verified_mobile.dart';
import 'package:saturn_login/widgets/mobile_input.dart';
import 'package:saturn_login/widgets/verify_code_button.dart';
import 'package:saturn_routers/sc_routers.dart';

class SCFindPasswordPage extends StatefulWidget {
  const SCFindPasswordPage({Key? key, this.areaCode}) : super(key: key);

  final Map<String, String>? areaCode;

  @override
  State<SCFindPasswordPage> createState() => _SCFindPasswordPageState();
}

class _SCFindPasswordPageState extends State<SCFindPasswordPage> {
  var _selectedArea = {};
  var _limitLength = 11;
  late ValueNotifier<bool> _btnDisabledNoti;

  final TextEditingController _mobileCon = TextEditingController();
  final TextEditingController _codeCon = TextEditingController();
  final FocusNode _mobileNode = FocusNode(debugLabel: 'mobile');
  final FocusNode _codeNode = FocusNode(debugLabel: 'code');

  @override
  void initState() {
    super.initState();
    _btnDisabledNoti = ValueNotifier(true);
    _selectedArea = widget.areaCode ?? {"中国": "86"};
    _mobileCon.addListener(() {
      if (_mobileCon.text.isNotEmpty && _codeCon.text.isNotEmpty) {
        _btnDisabledNoti.value = false;
      } else {
        _btnDisabledNoti.value = true;
      }
    });
    _codeCon.addListener(() {
      if (_mobileCon.text.isNotEmpty && _codeCon.text.isNotEmpty) {
        _btnDisabledNoti.value = false;
      } else {
        _btnDisabledNoti.value = true;
      }
    });
  }

  @override
  void dispose() {
    _mobileCon.dispose();
    _codeCon.dispose();
    _btnDisabledNoti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: STButton.icon(
          backgroundColor: Colors.transparent,
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onTap: () {
            SCRouters.pop(context);
          },
        ),
      ),
      body: BlankPutKeyborad(
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: SCLoginConstant.horFix16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: SCLoginConstant.spaceFix34,
                  bottom: SCLoginConstant.spaceFix46,
                ),
                child: Text(
                  '找回登录密码',
                  style: SCConfig.instance()
                      .getTextStyle(SCConfigConstant.titleFirTextStyle),
                ),
              ),
              SCMobileInput(
                areaStr: _selectedArea.values.first,
                controller: _mobileCon,
                focusNode: _mobileNode,
                mobileLength: _limitLength,
                onChanged: (String value) {
                  if (value.length == _limitLength) {
                    if (!_verifyMobile(value)) return;
                    Future.delayed(const Duration(milliseconds: 50), () {
                      FocusScope.of(context).requestFocus(_codeNode);
                    });
                  }
                },
                onTap: () {
                  final areaCodePage = SCAreaCodePage(
                    onChanged: (Map<String, String> selected) {
                      setState(() {
                        _selectedArea = selected;
                        final temp =
                            SCAreaCodeConstant.worldCodeLengths[_selectedArea];
                        if (temp == null) return;
                        _limitLength = int.tryParse(temp) ?? 11;
                      });
                    },
                  );
                  SCRouters.push(
                    context,
                    areaCodePage,
                    direction: SCRoutersDirection.bottomToTop,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: SCLoginConstant.horFix16,
                  bottom: SCLoginConstant.spaceFix36,
                ),
                child: STInput(
                  controller: _codeCon,
                  focusNode: _codeNode,
                  inputType: TextInputType.number,
                  textStyle: SCTextStyleConst.inputTextStyle,
                  backgoundColor: SCColorConst.inputBgColor,
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  suffixIcon: const SCVerifyCodeButton(baseStr: '获取验证码'),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _btnDisabledNoti,
                  builder: (cnt, bool disabled, _) {
                    return STButton(
                      disabled: disabled,
                      text: "下一步",
                      textStyle: SCTextStyleConst.btnFirTextStyle,
                      mainAxisSize: MainAxisSize.max,
                      onTap: () {
                        SCRouters.push(
                          context,
                          SCResetPasswordPage(
                            mobile: _mobileCon.text,
                          ),
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
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
