import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class GithubApi {
  BuildContext context;
  Options _options;

  static Dio dio = new Dio(BaseOptions(
    baseUrl: 'https://api.github.com/',
    headers: {
      // TODO: 语法？
      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
          "application/vnd.github.symmetra-preview+json",
    }
  ));

  static void init() {

  }
}