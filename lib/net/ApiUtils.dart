import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:flutter_haha/model/HahaListResponse.dart';

class ApiUtils {
  static const String BasicUrl = "http://www.haha.mx/mobile_app_data_api.php";


  static hahaListRequest(Function call) async {
    try {
      Response response;
      response = await Dio().request(
        "",
        data: {
          "r": "joke_list",
          "type": "web_good",
          "page": 1,
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
      call(hahaListResponse);
    } catch (e) {
      print(e);
    }
  }
}
