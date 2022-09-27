class SCVerifiedMobile {
  static const regExpMap = {
    "86": '1[345789]\\d{9}', // 中国
    "852": "([6|9])\\d{7}", // 香港
    "853": "9\\d{8}", // 台湾
    "44": " 7\\d{9}", // 英国
    "1": "[2-9]\\d{2}[2-9](?!11)\\d{6}", // 美国
    "81": "\\d{1,4}\\d{1,4}\\d{4}", // 日本
    "63": "\\d{10}", // 菲律宾
    "60": "{1}(([145]{1}\\d{7,8})|([236789]{1}\\d{7}))", // 马来西亚
    "966": "5\\d{8}", // 沙特阿拉伯
  };

  // 校验手机号是否正确
  static bool verifyMobile({
    required String value,
    required String area,
  }) {
    final rexStr = SCVerifiedMobile.regExpMap[area];
    if (rexStr == null) return true;
    RegExp regExp = RegExp(rexStr);
    return regExp.hasMatch(value);
  }
}
