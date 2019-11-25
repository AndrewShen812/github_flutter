import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class GhLocalizations {

  bool isZh = false;

  GhLocalizations(this.isZh);

  static GhLocalizations of(BuildContext context) {
    return Localizations.of<GhLocalizations>(context, GhLocalizations);
  }

  String get yes => isZh ? "确定" : "Yes";
  String get cancel => isZh ? "取消" : "Cancel";
  String get home => isZh ? "Github客户端" : "Github App";
  String get login => isZh ? "登录" : "Login";
  String get language => isZh ? "语言" : "Language";
  String get auto => isZh ? "跟随系统" : "Auto";
  String get userName => isZh ? "用户名" : "User";
  String get userNameOrEmail => isZh ? "用户名称或邮箱" : "User name or Email";
  String get userNameRequired => isZh ? "用户名不能为空" : "User name required.";
  String get password => isZh ? "密码" : "Password";
  String get passwordRequired => isZh ? "密码不能为空" : "Password required.";
  String get userNameOrPasswordWrong => isZh ? "用户名或密码错误" : "User name or password wrong.";
  String get theme => isZh ? "主题色" : "Theme Color";
  String get logout => isZh ? "注销" : "Sign out";
  String get logoutTip => isZh ? "确认要注销登录吗？" : "Are you sure to sign out?";
  String get noRepoDesp => isZh ? "该项目暂无描述信息" : "No description provided.";
}

class GhLocalizetionsDelegate extends LocalizationsDelegate<GhLocalizations> {
  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<GhLocalizations> load(Locale locale) {
    return SynchronousFuture<GhLocalizations>(
        GhLocalizations(locale.languageCode == 'zh')
    );
  }

  @override
  bool shouldReload(LocalizationsDelegate<GhLocalizations> old) {
    return false;
  }
}