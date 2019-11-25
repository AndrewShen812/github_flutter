import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:github_flutter/common/global.dart';

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

class CacheInterceptor extends Interceptor {
  // 为确保迭代器顺序和对象插入时间顺序一致，使用LinkedHashMap
  var cache = LinkedHashMap<String, CacheObj>();

  @override
  onRequest(RequestOptions options) async {
    if (!Global.profile.cache.enable) {
      return options;
    }
    // 下拉刷新标记
    bool refresh = options.extra["refresh"];
    if (refresh) {
      // 下拉刷新删除相关缓存
      if (options.extra["list"] == true) {
        //若是列表，则只要url中包含当前path的缓存全部删除（简单实现，并不精准）
        cache.removeWhere((k, v) => k.contains(options.path));
      } else {
        // 如果不是列表，则只删除uri相同的缓存
        delete(options.uri.toString());
      }
      return options;
    }
    if (options.extra["onCache"] != true
        && options.method.toLowerCase() == 'get') {
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      var obj = cache[key];
      if (obj != null) {
        // 缓存是否过期
        bool overdue = (DateTime.now()
            .millisecondsSinceEpoch - obj.timestamp) / 1000
          > Global.profile.cache.maxAge;
        if (overdue) {
          //若已过期则删除缓存，继续向服务器请求
          cache.remove(key);
        } else {
          return cache[key].response;
        }
      }
    }
  }

  void delete(String key) {
    cache.remove(key);
  }

  @override
  onError(DioError err) async {

  }

  @override
  onResponse(Response response) async {
    // 如果启用缓存，将返回结果保存到缓存
    if (Global.profile.cache.enable) {
      _saveCache(response);
    }
  }

  void _saveCache(Response response) {
    RequestOptions options = response.request;
    if (options.extra["noCache"] != true
        && options.method.toLowerCase() == "get") {
      // 如果缓存数量超过最大数量限制，则先移除最早的一条记录
      if (cache.length == Global.profile.cache.maxCount) {
        cache.remove(cache[cache.keys.first]);
      }
      String key = options.extra["cacheKey"] ?? options.uri.toString();
      cache[key] = CacheObj(response);
    }
  }
}