import 'package:dio/dio.dart';
import 'package:sarvoday_marine/core/api_handler/token_manager.dart';
import 'package:sarvoday_marine/core/navigation/app_route.dart';
import 'package:sarvoday_marine/core/navigation/app_route.gr.dart';

class DioClient {
  static DioClient? _instance;
  late Dio dio;

  DioClient._internal() {
    dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await TokenManager.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
            options.headers['Content-Type'] = 'application/json';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            _redirectToLogin();
          }
          return handler.next(error);
        },
      ),
    );
  }

  static DioClient getInstance() {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  void _redirectToLogin() {
    TokenManager.clearToken();
    final appRouter = AppRouter();
    appRouter.replaceAll([SignInRoute()]);
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    return dio.post(url, data: data);
  }

  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    return dio.put(url, data: data);
  }

  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    return dio.delete(url, data: data);
  }
}
