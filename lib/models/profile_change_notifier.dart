import 'dart:math';

import 'package:flutter/material.dart';
import 'package:github_flutter/common/global.dart';
import 'package:github_flutter/models/profile.dart';
import 'package:github_flutter/models/user.dart';

class ProfileChangeNotifier extends ChangeNotifier {

  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile();
    super.notifyListeners();
  }

}

/// 用户状态
class UserModel extends ProfileChangeNotifier {

  User get user => _profile.user;

  bool get isLogin => user != null;

  set user(User user) {
    if (user?.login != _profile.user?.login) {
      _profile.lastLogin = _profile.user?.login;
      _profile.user = user;
      notifyListeners();
    }
  }
}

/// 主题色状态
class ThemeModel extends ProfileChangeNotifier {
  ColorSwatch get theme {
    return Global.themes.firstWhere((e) {
      return e.value == _profile.theme;
    },
      orElse: () => Colors.blue
    );
  }

  set theme(ColorSwatch color) {
    if (color != theme) {
      _profile.theme = color[500].value;
      notifyListeners();
    }
  }
}

/// 语言状态
class LocaleModel extends ProfileChangeNotifier {
  Locale getLocale() {
    if (_profile.locale == null) {
      return null;
    }
    var loc = _profile.locale.split("_");
    return Locale(loc[0], loc[1]);
  }

  String get locale => _profile.locale;

  set locale(String locale) {
    if (locale != _profile.locale) {
      _profile.locale = locale;
      notifyListeners();
    }
  }
}