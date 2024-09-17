import 'package:dio/dio.dart';
import 'dart:io';

class DioErrorHandler {
  static String handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return "Request was cancelled. Please try again.";
      case DioExceptionType.connectionTimeout:
        return "Connection timed out. Please check your internet connection and try again.";
      case DioExceptionType.receiveTimeout:
        return "The server is taking too long to respond. Please try again later.";
      case DioExceptionType.sendTimeout:
        return "Unable to send data. Please check your connection and try again.";
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          return _handleStatusCode(
              dioError.response!.statusCode, dioError.message);
        } else {
          return "Something went wrong. Please try again later.";
        }
      case DioExceptionType.badCertificate:
        return "The server's security certificate is not valid. Please contact support.";
      case DioExceptionType.connectionError:
        if (dioError.error is SocketException) {
          return "Server Failure! Please try again in sometime";
        } else {
          return "An unexpected error occurred. Please try again later.";
        }
      default:
        return "An unknown error occurred. Please try again.";
    }
  }

  static String _handleStatusCode(int? statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return message ??
            "There was an issue with your request. Please try again.";
      case 401:
        return "You are not authorized. Please log in and try again.";
      case 403:
        return message ?? "You do not have permission to access this resource.";
      case 404:
        return message ?? "The requested resource could not be found.";
      case 500:
        return "The server encountered an error. Please try again later.";
      case 502:
        return "Bad Gateway. Please try again later.";
      case 503:
        return "The service is currently unavailable. Please try again later.";
      case 504:
        return "The server is taking too long to respond. Please try again later.";
      default:
        return "Something went wrong. Please try again.";
    }
  }
}
