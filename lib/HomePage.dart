import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication auth = LocalAuthentication();

  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
      floatingActionButton: _authButton(),
    );
  }

  Widget _authButton() {
    return FloatingActionButton(
      onPressed: () async {
        if (!_isAuthenticated) {
          final bool canAuthenticateWithBiometric =
              await auth.canCheckBiometrics;
          if (canAuthenticateWithBiometric) {
            try {
              final bool didAuthenticate = await auth.authenticate(
                  localizedReason:
                      'Please authenticate to show account balance',
                  options: const AuthenticationOptions(biometricOnly: false));
              setState(() {
                _isAuthenticated = didAuthenticate;
              });
            } catch (e) {
              print(e);
            }
          }
        } else {
          setState(() {
            _isAuthenticated = false;
          });
        }
      },
      child: Icon(_isAuthenticated ? Icons.lock : Icons.lock_open),
    );
  }

  Widget _buildUi() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Account Balance",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _isAuthenticated == true ? '\$24,000' : '******',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
