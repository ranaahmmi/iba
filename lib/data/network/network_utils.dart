import 'package:dio/dio.dart';
import 'package:iba/data/network/api.dart';
import 'package:iba/data/network/exceptions.dart';
import 'package:nb_utils/nb_utils.dart';

const noInternetMsg = 'You are not connected to Internet';

class NetworkUtil {
  Dio? _dioWithToken;
  Dio? _dioWithoutToken;

  NetworkUtil() {
    // if (_dioWithToken == null) {
    //   BaseOptions options =  BaseOptions(
    //       baseUrl: baseUrl,
    //       headers: {
    //         // "Authorization": 'Bearer ${gettoken()}',
    //         "Accept": "application/json"
    //       },
    //       receiveDataWhenStatusError: true,
    //       connectTimeout: 15 * 1000, // 15 seconds
    //       receiveTimeout: 15 * 1000 // 15 seconds
    //       );

    //   _dioWithToken =  Dio(options);
    // }
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        headers: {"Accept": "application/json"},
        receiveDataWhenStatusError: true,
        connectTimeout: 15 * 1000, // 15 seconds
        receiveTimeout: 15 * 1000 // 15 seconds
        );

    _dioWithoutToken = Dio(options);
  }

  Future getRequest({
    required String api,
    Map<String, dynamic> body = const {},
    bool sendToken = false,
  }) async {
    if (await isNetworkAvailable()) {
      {
        try {
          Response response = sendToken
              ? await _dioWithToken!.get(api, queryParameters: body)
              : await _dioWithoutToken!.get(api, queryParameters: body);
          return response.data;
        } on DioError catch (e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print("Network layer: $errorMessage");
          throw errorMessage;
        }
      }
    } else {
      throw noInternetMsg;
    }
  }

  Future postRequest({
    required String api,
    Map<String, dynamic> body = const {},
    bool sendToken = false,
  }) async {
    try {
      Response response = sendToken
          ? await _dioWithToken!.post(api, data: body)
          : await _dioWithoutToken!.post(api, data: body);
      return response.data;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();

      print("Network layer: $errorMessage");
      throw errorMessage;
    }
  }

  Future postRequestwithMedia({
    required String api,
    Map<String, dynamic> body = const {},
    bool sendToken = false,
  }) async {
    if (await isNetworkAvailable()) {
      try {
        Response response = sendToken
            ? await _dioWithToken!.post(api, data: FormData.fromMap(body))
            : await _dioWithoutToken!.post(api, data: FormData.fromMap(body));
        return response.data;
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();

        print("Network layer: $errorMessage");
        throw errorMessage;
      }
    } else {
      throw noInternetMsg;
    }
  }

  Future deleteRequest({
    required String api,
    bool sendToken = false,
  }) async {
    if (await isNetworkAvailable()) {
      try {
        Response response = sendToken
            ? await _dioWithToken!.delete(
                api,
              )
            : await _dioWithoutToken!.delete(
                api,
              );
        return response.data;
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();

        print("Network layer: $errorMessage");
        throw errorMessage;
      }
    } else {
      throw noInternetMsg;
    }
  }

  Future putRequest({
    required String api,
    Map<String, dynamic> body = const {},
    bool sendToken = false,
  }) async {
    if (await isNetworkAvailable()) {
      try {
        Response response = sendToken
            ? await _dioWithToken!.put(api, data: body)
            : await _dioWithoutToken!.put(api, data: body);
        return response.data;
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();

        print("Network layer: $errorMessage");
        throw errorMessage;
      }
    } else {
      throw noInternetMsg;
    }
  }

  Future putRequestwithMedia({
    required String api,
    Map<String, dynamic> body = const {},
    bool sendToken = false,
  }) async {
    if (await isNetworkAvailable()) {
      try {
        Response response = sendToken
            ? await _dioWithToken!.put(api, data: FormData.fromMap(body))
            : await _dioWithoutToken!.put(api, data: FormData.fromMap(body));
        return response.data;
      } on DioError catch (e) {
        final errorMessage = DioExceptions.fromDioError(e).toString();

        print("Network layer: $errorMessage");
        throw errorMessage;
      }
    } else {
      throw noInternetMsg;
    }
  }
}
