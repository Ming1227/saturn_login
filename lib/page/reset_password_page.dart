import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saturn/saturn.dart';
import 'package:saturn_login/page/login_page.dart';
import 'package:saturn_login/utils/config.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/utils/request_api.dart';
import 'package:saturn_routers/sc_routers.dart';

class SCResetPasswordPage extends StatefulWidget {
  const SCResetPasswordPage({Key? key, required this.mobile}) : super(key: key);

  final String mobile;

  @override
  State<SCResetPasswordPage> createState() => _SCResetPasswordPageState();
}

class _SCResetPasswordPageState extends State<SCResetPasswordPage> {
  late ValueNotifier<bool> _btnDisabledNoti;

  final TextEditingController _firstCon = TextEditingController();
  final TextEditingController _confirmCon = TextEditingController();

  @override
  void initState() {
    super.initState();
    _btnDisabledNoti = ValueNotifier(true);
    _firstCon.addListener(() {
      if (_firstCon.text.isNotEmpty && _confirmCon.text.isNotEmpty) {
        _btnDisabledNoti.value = false;
      } else {
        _btnDisabledNoti.value = true;
      }
    });
    _confirmCon.addListener(() {
      if (_firstCon.text.isNotEmpty && _confirmCon.text.isNotEmpty) {
        _btnDisabledNoti.value = false;
      } else {
        _btnDisabledNoti.value = true;
      }
    });
  }

  @override
  void dispose() {
    _firstCon.dispose();
    _confirmCon.dispose();
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
          padding: const EdgeInsets.symmetric(
            horizontal: SCLoginConstant.horFix16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: SCLoginConstant.spaceFix34,
                  bottom: SCLoginConstant.spaceFix46,
                ),
                child: Text(
                  '设置新密码',
                  style: SCConfig.instance()
                      .getTextStyle(SCConfigConstant.titleFirTextStyle),
                ),
              ),
              STInput.password(
                controller: _firstCon,
                inputFormatters: [LengthLimitingTextInputFormatter(20)],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: SCLoginConstant.horFix16,
                ),
                child: STInput.password(
                  controller: _confirmCon,
                  inputFormatters: [LengthLimitingTextInputFormatter(20)],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _btnDisabledNoti,
                  builder: (cnt, bool disabled, _) {
                    return STButton(
                      disabled: disabled,
                      text: "确定",
                      textStyle: SCTextStyleConst.btnFirTextStyle,
                      mainAxisSize: MainAxisSize.max,
                      onTap: _sureAction,
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  void _sureAction() async {
    if (_firstCon.text.isEmpty) {
      STToast.show(context: context, message: '请输入密码');
      return;
    } else if (_confirmCon.text.isEmpty) {
      STToast.show(context: context, message: '请输入确认密码');
      return;
    } else if (_firstCon.text != _confirmCon.text) {
      STToast.show(context: context, message: '两次密码输入不一致');
      return;
    }
    // 请求接口
    final result = SCResult.success();
    if (result.success) {
      STToast.show(context: context, message: '设置密码成功');
      SCRouters.popUtil(context, SCLoginPage.routeName);
    }
  }
}
