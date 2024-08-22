import 'client.dart';
import 'rest_client.dart';

const _kDefaultAppKey = 'default';

Client getNakamaClient({
  String? host,
  String? serverKey,
  String key = _kDefaultAppKey,
  int httpPort = 7350,
  int grpcPort = 7349,
  bool ssl = false,
}) =>
    RestClient.init(
      host: host,
      key: key,
      port: httpPort,
      serverKey: serverKey,
      ssl: ssl,
    );
