import 'package:authentication_quickstart/common/authentication_providers.dart';
import 'package:authentication_quickstart/common/styles/text_styles.dart';
import 'package:authentication_quickstart/widgets/login_provider_chip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/application_state.dart';

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
          Text(
            'Firebase Auth',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            'Identity Providers',
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
          ),
          Consumer<ApplicationState>(
            builder: (context, appState, _) => LoginProviderChip(
              providerIcon: const Icon(Icons.supervised_user_circle_outlined),
              providerName: 'Anonymouse',
              onClick: () =>
                  {appState.login(AuthenticationProviders.anonymous)},
            ),
          ),
        ],
      ),
    );
  }
}
