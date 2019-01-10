import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter_haha/model/HahaListResponse.dart';

class ApiUtils {
  static const String BasicUrl = "http://www.haha.mx/mobile_app_data_api.php";

  static Future<HahaListResponse> hahaListRequest(loadMode, page) async {
    Response response;
    var dio = Dio();
    dio.interceptor.request.onSend = (options) {
      print('dioUrl:${options.baseUrl}${options.path} '
          'data:${options.data.toString()}');
      return options;
    };
    response = await dio.request(
      "",
      data: {
        "r": "joke_list",
        "type": "web_good",
        "page": page,
        "id": 1,
        "range": ""
      },
      options: Options(
        baseUrl: BasicUrl,
        connectTimeout: 5000,
        receiveTimeout: 3000,
      ),
    );
    Map srcJson = json.decode(response.data.toString());
    HahaListResponse hahaListResponse = HahaListResponse.fromJson(srcJson);
    return hahaListResponse;
  }
}
