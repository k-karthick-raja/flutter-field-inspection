import 'package:dio/dio.dart';
import 'package:field_inspection/core/network/api_client.dart';
import 'package:field_inspection/core/network/mock_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('serves the bundled inspections fixture', () async {
    final dio = createApiClient(mock: MockInterceptor());

    final response = await dio.get<List<dynamic>>('/inspections');

    expect(response.statusCode, 200);
    expect(response.data, hasLength(4));
    expect((response.data!.first as Map)['site_id'], 'site-001');
  });

  test('uses the injected loader for a custom route', () async {
    final dio = createApiClient(
      mock: MockInterceptor(
        routes: const {'GET /ping': 'ping.json'},
        loadAsset: (path) async => '{"ok": true}',
      ),
    );

    final response = await dio.get<Map<String, dynamic>>('/ping');

    expect(response.data, {'ok': true});
  });

  test('rejects unknown routes with a 404', () async {
    final dio = createApiClient(mock: MockInterceptor());

    await expectLater(
      dio.get<void>('/nope'),
      throwsA(
        isA<DioException>()
            .having((e) => e.response?.statusCode, 'status', 404),
      ),
    );
  });
}
