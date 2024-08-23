import 'package:meta/meta.dart';
import 'package:nakama/nakama.dart';
import 'package:test/test.dart';

const testHost = 'localhost';

enum ClientType {
  rest('REST'),
  grpc('gRPC');

  const ClientType(this.description);

  final String description;
}

class TestHelper {
  TestHelper({this.clientType = ClientType.grpc});

  final ClientType clientType;

  Client createClient() {
    final client = switch (clientType) {
      ClientType.rest => Client.rest(host: testHost),
      ClientType.grpc => Client.grpc(host: testHost),
    };

    addTearDown(client.close);

    return client;
  }

  Socket createSocket(Session session) {
    final socket = Socket(host: testHost, token: session.token);
    addTearDown(socket.close);
    return socket;
  }
}

@isTestGroup
void clientTests(
  String description,
  void Function(TestHelper helper) suite, {
  Object? skip,
}) {
  for (final type in ClientType.values) {
    group(
      '[${type.description}] $description',
      () => suite(TestHelper(clientType: type)),
      skip: skip,
    );
  }
}
