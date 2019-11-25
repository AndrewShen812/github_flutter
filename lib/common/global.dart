
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_flutter/common/cache.dart';
import 'package:github_flutter/common/github_api.dart';
import 'package:github_flutter/models/cacheConfig.dart';
import 'package:github_flutter/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themes = <MaterialColor>[
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.red,
];

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  // 网络缓存对象
  static CacheInterceptor netCache = CacheInterceptor();
  // 可选主题色列表
  static List<MaterialColor> get themes => _themes;
  // 是否为release版本
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }

    profile.cache = profile.cache ?? CacheConfig()
      ..enable = true
      ..maxAge = 3600
      ..maxCount = 100;

    GithubApi.init();
  }

  static saveProfile() {
    _prefs.setString("profile", jsonEncode(profile.toJson()));
  }
}