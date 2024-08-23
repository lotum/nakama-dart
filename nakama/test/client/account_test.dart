import 'package:faker/faker.dart';
import 'package:nakama/nakama.dart';
import 'package:test/test.dart';

import '../helpers.dart';

void main() {
  clientTests('Account', (helper) {
    late final Client client;
    late final Session session;

    setUpAll(() async {
      client = helper.createClient();

      session = await client.authenticateDevice(deviceId: faker.guid.guid());
    });

    test('fetching my account', () async {
      final account = await client.getAccount(session);

      expect(account, isA<Account>());
    });

    test('fetch another\'s account', () async {
      // create another dummy user
      final anotherUser = await client.authenticateDevice(
        deviceId: faker.guid.guid(),
      );

      // fetch this user
      final users = await client.getUsers(
        session: session,
        ids: [anotherUser.userId],
      );

      expect(users, isA<List<User>>());
      expect(users, hasLength(1));
    });

    test('updating my account', () async {
      await client.updateAccount(session: session, displayName: 'name');
    });
  });
}
