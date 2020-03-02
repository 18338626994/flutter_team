import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './hlm_plugin.dart';
import 'dart:convert' show JsonDecoder;

enum HttpMethod { POST, GET }

class HttpResponse<T> {
  T respData;
  String requestSeqId;
  String respCode;
  String respDesc;
  String respSeq;

  get innerData => respData;

  get stateCode => respCode;

  HttpResponse(
      {this.respData,
      this.requestSeqId,
      this.respCode,
      this.respDesc,
      this.respSeq});

  HttpResponse.copy(Response response) {
    var data = JsonDecoder().convert(response.data);
    if (data != null) {
      this.requestSeqId = data['requestSeqId'];
      this.respCode = data['respCode'];
      this.respDesc = data['respDesc'];
      this.respSeq = data['respSeq'];
      this.respData = data['respData'];
    }
  }
}

class HlmNetwork {
  Dio _dio;
  static HlmNetwork _instance;
  static const bool NEED_PROXY = false;

  HlmNetwork._() {
    _dio = Dio();
    if (NEED_PROXY) {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (url) {
          //注意！！此处是为了抓包用的，所以需要设置自己的代理IP
          if (Platform.isIOS) {
            return 'PROXY 172.31.21.38:8888';
          } else {
            return 'PROXY 172.31.46.42:8888';
          }
        };
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }

    _dio.interceptors.add(SignInterceptor());
  }

  static HlmNetwork shareInstance() {
    if (_instance == null) {
      _instance = HlmNetwork._();
    }
    return _instance;
  }

  Future<T> request<T>(String path,
      {HttpMethod method = HttpMethod.POST,
      Map<String, dynamic> queries}) async {
    try {
      Map<dynamic, dynamic> signedParams = await HlmPlugin().apiSign(queries);
      Response rawResp;
      if (method == HttpMethod.GET) {
        rawResp = await _dio.get(path,
            queryParameters: Map<String, dynamic>.from(signedParams));
      } else {
        String data = "";
        for (var key in signedParams.keys) {
          data += "$key=${signedParams[key]}&";
        }

        rawResp =
            await _dio.post(path, data: data.substring(0, data.length - 1));
      }
      HttpResponse<T> response = HttpResponse.copy(rawResp);
      return response.innerData;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class SignInterceptor extends Interceptor {
  Future onRequest(RequestOptions options) async {
    String host = 'https://mcsmertest.cloudpnr.com/api';
    //await HlmPlugin().getApiBaseUrl();

    options.baseUrl = host;
    options.headers
        .putIfAbsent("Content-Type", () => 'application/x-www-form-urlencoded');
    options.headers.putIfAbsent("Accept-Encoding", () => 'gzip');
    options.headers.putIfAbsent("Connection", () => 'Keep-Alive');
    options.headers
        .putIfAbsent('Accept', () => 'application/json;charset=utf-8');
    return options;
  }
}
