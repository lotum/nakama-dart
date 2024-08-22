import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:nakama/nakama.dart';

import 'widgets/match_area.dart';
import 'widgets/matchmaker.dart';
import 'widgets/sign_in_box.dart';
import 'widgets/welcome.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: _HomeScreen(),
  ));
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  __HomeScreenState createState() => __HomeScreenState();
}

class __HomeScreenState extends State<_HomeScreen> {
  late final Client _client;

  bool signInError = false;

  Session? _session;
  Account? _account;
  Match? _match;

  @override
  void initState() {
    super.initState();

    _client = getNakamaClient(
      host: '127.0.0.1',
      ssl: false,
      serverKey: 'defaultkey',
    );
  }

  @override
  void dispose() {
    Socket.instance.close();
    super.dispose();
  }

  void _signIn(String email, String password) async {
    setState(() {
      signInError = false;
    });

    try {
      final session = await _client.authenticateEmail(
        email: email,
        password: password,
        create: true,
      );

      // sign in was successful
      final profile = await _client.getAccount(session);

      setState(() {
        _session = session;
        _account = profile;
      });

      Socket.init(
        host: '127.0.0.1',
        ssl: false,
        token: _session!.token,
      );
    } catch (_) {
      // sign in failed
      setState(() {
        signInError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nakama Flutter Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _session != null && _account != null
            ? Column(
                children: [
                  Welcome(_account!),
                  if (_match == null)
                    Matchmaker(
                      onMatch: (m) => setState(() => _match = m),
                    ),
                  if (_match != null) MatchArea(_match!),
                ],
              )
            : Column(
                children: [
                  if (signInError)
                    const Text(
                      'Sign in failed. Please try again.',
                      style: TextStyle(color: Colors.red),
                    ),
                  SignInBox(onSignIn: _signIn),
                ],
              ),
      ),
    );
  }
}
