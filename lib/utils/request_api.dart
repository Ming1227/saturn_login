import 'package:saturn_login/utils/callbacks.dart';

class SCResult {
  final bool success;
  final int code;
  final String message;
  final dynamic data;
  final Error? error;

  SCResult({
    required this.success,
    required this.code,
    required this.message,
    this.error,
    this.data,
  });

  SCResult.errNull({
    this.success = false,
    this.code = 0,
    this.message = '存在null导致',
    this.data,
    this.error,
  });

  SCResult.error({
    this.success = false,
    this.code = 0,
    this.message = '存在一个错误',
    this.data,
    this.error,
  });

  SCResult.success({
    this.success = true,
    this.code = 200,
    this.message = '',
    this.data,
    this.error,
  });
}

class SCAPI {
  SCResultCallback? verifyCode;

  SCResultCallback? login;

  SCResultCallback? resetPS;

  SCAPI({
    this.verifyCode,
    this.login,
    this.resetPS,
  });

  Future<SCResult> requestVerifyCode(String mobile) async {
    if (verifyCode == null) return SCResult.errNull();
    return verifyCode!({"mobile": mobile});
  }

  Future<SCResult> requestLogin(String username,
      {String? pin, String? password}) async {
    if (login == null) return SCResult.errNull();
    if (pin != null) return login!({'user': username, 'pin': pin});
    return login!({'user': username, 'password': password});
  }

  Future<SCResult> requestResetPS(String password, String confirm) async {
    if (resetPS == null) return SCResult.errNull();
    return resetPS!({'password': password, 'confirm': confirm});
  }
}
