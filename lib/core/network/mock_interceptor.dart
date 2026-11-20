import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

typedef AssetLoader = Future<String> Function(String assetPath);

/// Answers API calls from JSON fixtures in `assets/fixtures/` so the app
/// runs end to end without a backend.
class MockInterceptor extends Interceptor {
  MockInterceptor({
    AssetLoader? loadAsset,
    this.latency = Duration.zero,
    Map<String, String>? routes,
  })  : _loadAsset = loadAsset ?? rootBundle.loadString,
        _routes = routes ?? defaultRoutes;

  /// `METHOD /path` → fixture asset.
  static const Map<String, String> defaultRoutes = {
    'GET /inspections': 'assets/fixtures/inspections.json',
    'GET /sites': 'assets/fixtures/sites.json',
  };

  final AssetLoader _loadAsset;
  final Duration latency;
  final Map<String, String> _routes;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final fixture = _routes['${options.method} ${options.path}'];
    if (latency > Duration.zero) await Future<void>.delayed(latency);

    if (fixture == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.badResponse,
          response: Response(requestOptions: options, statusCode: 404),
          message: 'No mock fixture for ${options.method} ${options.path}',
        ),
      );
      return;
    }

    final body = jsonDecode(await _loadAsset(fixture));
    handler.resolve(
      Response(requestOptions: options, statusCode: 200, data: body),
    );
  }
}
