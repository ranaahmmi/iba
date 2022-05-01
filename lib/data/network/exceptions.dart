import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioErrorType.connectTimeout:
        message = "Connection Timeout Internet issue or Server not response";
        break;
      case DioErrorType.other:
        message = "Connection to API server failed due to internet connection";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioErrorType.response:
        print(dioError.response!.data);
        if (dioError.response!.statusCode == 401) {
          message = "Unauthorized";
        } else {
          final Map a = dioError.response!.data['errors'] as Map;
          message = '';
          a.forEach((key, value) {
            message += "$key :\n $value\n";
            print(message);
          });
        }

        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  late String message;

  @override
  String toString() => message;
}
