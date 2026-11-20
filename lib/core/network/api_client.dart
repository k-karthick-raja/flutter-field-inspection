import 'package:dio/dio.dart';

import 'mock_interceptor.dart';

const String apiBaseUrl = 'https://api.field-inspection.example';

/// Builds the app's [Dio] instance. Pass [useMock] = false once a real
/// backend exists.
Dio createApiClient({bool useMock = true, MockInterceptor? mock}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  if (useMock) {
    dio.interceptors.add(
      mock ?? MockInterceptor(latency: const Duration(milliseconds: 400)),
    );
  }
  return dio;
}
