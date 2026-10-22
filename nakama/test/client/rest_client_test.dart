import 'package:dio/dio.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama/src/rest_client.dart';
import 'package:test/test.dart';

void main() {
  late RestClient client;

  setUp(() {
    client = RestClient(
      host: 'localhost',
      httpPort: 7350,
      grpcPort: 7349,
      ssl: false,
      serverKey: 'defaultkey',
      retryPolicy: RetryPolicy.noRetries,
      autoRefreshSession: false,
      requestTimeout: const Duration(seconds: 5),
    );
  });

  tearDown(() => client.close());

  for (final type in DioExceptionType.values.where(
    (type) => type.name.endsWith('Timeout'),
  )) {
    test('$type is translated to deadline exceeded', () {
      final error = client.translateException(DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: type,
      ));

      expect(error?.code, ErrorCode.deadlineExceeded);
    });
  }

  test('cancellation is not translated into a server error', () {
    final error = client.translateException(DioException(
      requestOptions: RequestOptions(path: '/test'),
      type: DioExceptionType.cancel,
    ));

    expect(error, isNull);
  });
}
