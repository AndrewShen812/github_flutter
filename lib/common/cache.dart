import 'dart:collection';

import 'package:dio/dio.dart';

class CacheObj {
  CacheObj(this.response)
    : timestamp = DateTime.now().millisecondsSinceEpoch;

  Response response;
  int timestamp;

  @override
  bool operator ==(other) {
    return response.hashCode == other.hashCode;
  }

  @override
  int get hashCode => response.realUri.hashCode;
}

class NetCache extends Interceptor {
  var cache = LinkedHashMap<String, CacheObj>();

  @override
  onRequest(RequestOptions options) async {

  }
}