import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_haha/net/ErrorData.dart';
import 'package:flutter_haha/app/i18n.dart';

class ApiUtils {
  static const String BasicUrl = "http://www.haha.mx/mobile_app_data_api.php";

  static Future fetchPost({String path = "", dynamic data}) async {
    try {
      Response response;
      var dio = Dio();
      dio.interceptor.request.onSend = (options) {
        print('dioUrl:${options.baseUrl}${options.path} '
            'data:${options.data.toString()}');
        return options;
      };
      response = await dio.request(
        path,
        data: data,
        options: Options(
          baseUrl: BasicUrl,
          connectTimeout: 5000,
          receiveTimeout: 3000,
        ),
      );
      Map srcJson = json.decode(response.data.toString());
      if (srcJson.isNotEmpty)
        return srcJson;
      else {
        throw NullThrownError();
      }
    } catch (e) {
      return parseException(e);
    }
  }

  static Future parseException(e) {
    //(option) 暂未配置业务异常：NetError.Invalid
    ErrorData errorData = ErrorData();
    if (e is DioError) {
      switch (e.type) {
        case DioErrorType.DEFAULT: //net error
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.CONNECT_TIMEOUT:
          {
            errorData.errorType = NetError.NetWork;
            errorData.message = e.message;
            break;
          }
        case DioErrorType.RESPONSE: //server error
          {
            errorData.errorType = NetError.Server;
            errorData.message = e.message;
            break;
          }
        case DioErrorType.CANCEL:
          {
            break;
          }
      }
    } else if (e is CastError) {
      //json parse not arrive？？
      errorData.errorType = NetError.Internal;
      errorData.message = e.toString();
    } else if (e is NullThrownError) {
      //empty data
      errorData.errorType = NetError.Invalid;
      errorData.message = i18n.ApiUtils_Data_Empty;
    } else {
      //unKnow
      errorData.errorType = NetError.UnKnow;
      errorData.message = e.toString();
    }
    return Future.error(errorData);
  }
}
