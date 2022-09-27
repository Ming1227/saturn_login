import 'package:flutter/material.dart';
import 'package:saturn/saturn.dart';
import 'package:saturn_login/page/webview_page.dart';
import 'package:saturn_login/utils/config.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/widgets/password_login.dart';
import 'package:saturn_login/widgets/verify_code_login.dart';
import 'package:saturn_routers/sc_routers.dart';

class SCLoginPage extends StatefulWidget {
  const SCLoginPage({Key? key}) : super(key: key);
  static const routeName = '/SC_login';
  @override
  State<SCLoginPage> createState() => _SCLoginPageState();
}

class _SCLoginPageState extends State<SCLoginPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: BlankPutKeyborad(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: screenWidth,
                    child: SCVerifyCodeLogin(
                      switchPasswordTap: (bool value) {
                        _scrollController.animateTo(
                          screenWidth,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SCPasswordLogin(
                      switchVerifyCodeTap: (bool value) {
                        _scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: SCLoginConstant.bottomFix),
              child: _buildBottom(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '登录即代表同意',
          style: SCConfig.instance()
              .getTextStyle(SCConfigConstant.smallSecTextStyle),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: STButton(
            type: STButtonType.text,
            text: '用户协议',
            textStyle: SCTextStyleConst.smallFirTextStyle,
            onTap: () {
              SCRouters.push(
                context,
                const SCWebViewPage(
                  title: '用户协议',
                ),
                direction: SCRoutersDirection.bottomToTop,
              );
            },
          ),
        ),
        Text(
          '和',
          style: SCConfig.instance()
              .getTextStyle(SCConfigConstant.smallSecTextStyle),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: STButton(
            type: STButtonType.text,
            text: '隐私政策',
            textStyle: SCTextStyleConst.smallFirTextStyle,
            onTap: () {
              SCRouters.push(
                context,
                const SCWebViewPage(
                  title: '隐私政策',
                ),
                direction: SCRoutersDirection.bottomToTop,
              );
            },
          ),
        ),
      ],
    );
  }
}
