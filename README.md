# saturn_login

一个登录模块的 module
包含登录、密码设置、密码找回等界面

## 使用方法

在依赖库中添加：

```
dependencies:
  saturn_login:
    git:
      url: https://github.com/Ming1227/saturn_login.git
```

在模块中存在一个**config 单例**
所有的颜色、字体、网络请求均通过单例去配置

```
void _configLogin() {
  SCConfig config = SCConfig.instance();
  config.colorConfig = {
    SCConfigConstant.inputBgColor: Colors.white,
  };
  config.textStyleConfig = {
    SCConfigConstant.inputTextStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  };
  config.api.verifyCode = (Map<String, dynamic> map) {
    return SCResult.success();
  };
  config.api.login = ((map) {
    return SCResult.success();
  });
  config.api.resetPS = ((map) {
    return SCResult.success();
  });
}
```

可在 main 函数内调用也可在 MyApp 是调用,例如：

```
class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configLogin();
  }

  ...
}
```

colorConfig 中配置了两种颜色

```
static const inputBgColor = 'sc_inputBgColor';
static const firBlueColor = 'sc_firBlueColor';

```

textStyleConfig 中配置了以下风格

```
static const inputTextStyle = 'sc_inputTextStyle';
static const btnFirTextStyle = 'sc_btnFirTextStyle';
static const btnSecTextStyle = 'sc_btnSecTextStyle';
static const btnThrTextStyle = 'sc_btnThrTextStyle';
static const titleFirTextStyle = 'sc_titleFirTextStyle';
static const titleFourTextStyle = 'sc_titleFourTextStyle';
static const smallFirTextStyle = 'sc_smallFirTextStyle';
static const smallSecTextStyle = 'sc_smallSecTextStyle';
```

**在配置 color 和 textStyle 时请通过 SCConfigConstant 内的值来配置**
