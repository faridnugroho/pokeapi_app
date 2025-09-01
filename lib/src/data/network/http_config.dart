import 'package:dio/dio.dart';

class HttpConfig {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pokeapi.co/api/v2',
      responseType: ResponseType.json,
      connectTimeout: Duration(seconds: 10),
      headers: {Headers.contentTypeHeader: Headers.jsonContentType, Headers.acceptHeader: '*/*'},
    ),
  );

  static Dio get dio => _dio;
}
