import 'package:authentication_quickstart/common/authentication_providers.dart';
import 'package:authentication_quickstart/main.dart';
import 'package:authentication_quickstart/widgets/login_provider_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ignore: todo
          // TODO(@nohe427): Eventually replace this with sliverAppBar
          // https://api.flutter.dev/flutter/material/SliverAppBar-class.html
          const Text('Firebase Auth'),
          const Text('Identity Providers'),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => LoginProviderChip(
              providerIcon: const Icon(Icons.g_mobiledata_outlined),
              providerName: 'Google',
              onClick: () => {
                appState.login(AuthenticationProviders.google),
              },
            ),
          ),
          LoginProviderChip(
            providerIcon: const Icon(Icons.g_mobiledata_outlined),
            providerName: 'Email / Password',
            onClick: () => {debugPrint('Google Login')},
          )
        ],
      ),
    );
  }
}
