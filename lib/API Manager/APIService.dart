import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<Response> postApi({
    required String endpoint,
    required Map<String, dynamic> param,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      return await dio.post(
        endpoint,
        data: param,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> getApi({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {};
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      return await dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> postFormDataApi({
    required String endpoint,
    required FormData formData,
    String? token,
  }) async {
    try {
      Map<String, String> headers = {};
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }

      return await dio.post(
        endpoint,
        data: formData,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}