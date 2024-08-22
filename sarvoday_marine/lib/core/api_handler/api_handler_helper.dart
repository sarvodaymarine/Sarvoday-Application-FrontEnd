import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sarvoday_marine/core/api_handler/token_manager.dart';

class DioClient {
  // The singleton instance
  static DioClient? _instance;

  // Dio instance
  late Dio dio;

  // Private constructor
  DioClient._internal(BuildContext context) {
    dio = Dio();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add authorization token to request headers
          String? token = await TokenManager.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired or unauthorized, redirect to login
            _redirectToLogin(context);
          }
          return handler.next(error);
        },
      ),
    );
  }

  // Singleton access point
  static DioClient getInstance(BuildContext context) {
    _instance ??= DioClient._internal(context);
    return _instance!;
  }

  // Method to redirect to login
  void _redirectToLogin(BuildContext context) {
    TokenManager.clearToken();

    // Navigate to login and clear all previous routes
  }

  // Example of a GET request
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return dio.get(url, queryParameters: queryParameters);
  }

  // Example of a POST request
  Future<Response> post(String url, {Map<String, dynamic>? data}) async {
    return dio.post(url, data: data);
  }

  // Example of a PUT request
  Future<Response> put(String url, {Map<String, dynamic>? data}) async {
    return dio.put(url, data: data);
  }

  // Example of a DELETE request
  Future<Response> delete(String url, {Map<String, dynamic>? data}) async {
    return dio.delete(url, data: data);
  }
}
