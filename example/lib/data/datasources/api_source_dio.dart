// ignore_for_file: avoid-dynamic, avoid-collection-mutating-methods

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:example/domain/datasources/api_source.dart';
import 'package:trackit/trackit.dart';

/// [Dio] implementation [ApiSource].
class ApiSourceDio extends ApiSource {
  static final _log = Trackit.create('ApiSourceDio');
  late Dio _dio;
  final String baseUrl;
  final List<Interceptor>? interceptors;

  ApiSourceDio({required this.baseUrl, Dio? dio, this.interceptors}) {
    _dio = dio ?? Dio();
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 300)
      ..options.receiveTimeout = const Duration(seconds: 300)
      ..httpClientAdapter
      ..options.headers = {
        Headers.contentTypeHeader: 'application/json; charset=UTF-8',
      }
      ..interceptors.addAll(interceptors ?? []);
  }

  @override
  Future<T?> get<T>(
    String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.get<T>(
      uri,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );

    return response.data;
  }

  @override
  Future<T?> post<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.post<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return response.data;
  }

  @override
  Future<T?> patch<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final response = await _dio.patch<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return response.data;
  }

  @override
  Future<T?> delete<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.delete<T>(
      uri,
      data: data,
      queryParameters: queryParameters,
      options: headers == null ? null : Options(headers: headers),
      cancelToken: cancelToken,
    );

    return response.data;
  }
}
