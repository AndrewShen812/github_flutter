import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:github_flutter/common/global.dart';
import 'package:github_flutter/models/repo.dart';
import 'package:github_flutter/models/user.dart';

class GithubApi {
  BuildContext context;
  Options _options;

  static Dio dio = new Dio(BaseOptions(
    baseUrl: 'https://api.github.com/',
    headers: {
      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json",
    }
  ));

  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  GithubApi([this.context]) {
    _options = Options(extra: {"context": context});
  }

  static void init() {
    dio.interceptors.add(Global.netCache);
    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (!Global.isRelease) {
      // FIXME 2019/11/25: 有需要打开
      /*(dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
        client.findProxy = (uri) => "PROXY 192.168.1.16:8888";
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      };*/
    }
  }

  /// 登录接口，登录成功后返回用户信息
  Future<User> login(String user, String pwd) async {
    String basic = 'Basic ' + base64.encode(utf8.encode("$user:$pwd"));
    var r = await dio.get("/users/$user",
      options: _options.merge(
        headers: {
          HttpHeaders.authorizationHeader: basic
        },
        extra: {
          "noCache": true,
          "refresh": false,
        }
      )
    );
    //登录成功后更新公共头（authorization），此后的所有请求都会带上用户身份信息
    dio.options.headers[HttpHeaders.authorizationHeader] = basic;
    Global.netCache.cache.clear();
    //更新profile中的token信息
    Global.profile.token = basic;
    return User.fromJson(r.data);
  }

  /// 获取用户项目列表
  Future<List<Repo>> getRepos({
    Map<String, dynamic> queryParams,
    refresh = false
  }) async {
    _options.extra["refresh"] = refresh;
    _options.extra["list"] = true;
    var r = await dio.get<List>(
      "user/repos",
      queryParameters: queryParams,
      options: _options
    );
    return r.data.map((e) => Repo.fromJson(e)).toList();
  }
}