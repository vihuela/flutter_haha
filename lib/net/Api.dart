import 'package:flutter_haha/model/HahaListResponse.dart';
import 'package:flutter_haha/net/ApiUtils.dart';

class Api {
  static Future<HahaListResponse> hahaListRequest(page) async {
    Map srcJson = await ApiUtils.fetchPost(data: {
      "r": "joke_list",
      "type": "web_good",
      "page": page,
      "id": 1,
      "range": ""
    });
    return HahaListResponse.fromJson(srcJson);
  }
}
