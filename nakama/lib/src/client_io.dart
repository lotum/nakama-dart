import 'client.dart';
import 'grpc_client.dart';

const _kDefaultAppKey = 'default';

Client getNakamaClient({
  String? host,
  String? serverKey,
  String key = _kDefaultAppKey,
  int httpPort = 7350,
  int grpcPort = 7349,
  bool ssl = false,
}) =>
    GrpcClient.init(
      host: host,
      key: key,
      port: grpcPort,
      serverKey: serverKey,
      ssl: ssl,
    );
