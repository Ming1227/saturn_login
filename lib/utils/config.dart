import 'package:flutter/material.dart';
import 'package:saturn_login/utils/login_constant.dart';
import 'package:saturn_login/utils/request_api.dart';

class SCConfig {
  static SCConfig? _config;

  SCConfig({
    required this.api,
    required this.colorConfig,
    required this.textStyleConfig,
  });

  static SCConfig instance() {
    _config ??= SCConfig(
      api: SCAPI(),
      colorConfig: colorMap,
      textStyleConfig: textStyleMap,
    );
    return _config!;
  }

  final SCAPI api;

  final Map<String, Color> colorConfig;

  final Map<String, TextStyle> textStyleConfig;

  set colorConfig(Map<String, Color>? config) {
    if (config == null) return;
    final baseConfig = colorMap;
    config.forEach((key, value) {
      baseConfig[key] = value;
    });
    colorConfig = baseConfig;
  }

  set textStyleConfig(Map<String, TextStyle>? config) {
    if (config == null) return;
    final baseConfig = textStyleMap;
    config.forEach((key, value) {
      baseConfig[key] = value;
    });
    textStyleConfig = baseConfig;
  }

  Color getColor(String key) {
    if (colorConfig.keys.contains(key)) {
      return colorConfig[key]!;
    }
    return Colors.black;
  }

  TextStyle getTextStyle(String key) {
    if (textStyleConfig.keys.contains(key)) {
      return textStyleConfig[key]!;
    }
    return const TextStyle();
  }
}

class SCConfigConstant {
  static const inputBgColor = 'sc_inputBgColor';
  static const firBlueColor = 'sc_firBlueColor';

  static const inputTextStyle = 'sc_inputTextStyle';
  static const btnFirTextStyle = 'sc_btnFirTextStyle';
  static const btnSecTextStyle = 'sc_btnSecTextStyle';
  static const btnThrTextStyle = 'sc_btnThrTextStyle';
  static const titleFirTextStyle = 'sc_titleFirTextStyle';
  static const titleFourTextStyle = 'sc_titleFourTextStyle';
  static const smallFirTextStyle = 'sc_smallFirTextStyle';
  static const smallSecTextStyle = 'sc_smallSecTextStyle';
}

final Map<String, Color> colorMap = {
  SCConfigConstant.inputBgColor: SCColorConst.inputBgColor,
  SCConfigConstant.firBlueColor: SCColorConst.firBlueColor,
};

final Map<String, TextStyle> textStyleMap = {
  SCConfigConstant.inputTextStyle: SCTextStyleConst.inputTextStyle,
  SCConfigConstant.btnFirTextStyle: SCTextStyleConst.btnFirTextStyle,
  SCConfigConstant.btnSecTextStyle: SCTextStyleConst.btnSecTextStyle,
  SCConfigConstant.btnThrTextStyle: SCTextStyleConst.btnThrTextStyle,
  SCConfigConstant.titleFirTextStyle: SCTextStyleConst.titleFirTextStyle,
  SCConfigConstant.titleFourTextStyle: SCTextStyleConst.titleFourTextStyle,
  SCConfigConstant.smallFirTextStyle: SCTextStyleConst.smallFirTextStyle,
  SCConfigConstant.smallSecTextStyle: SCTextStyleConst.smallSecTextStyle,
};
