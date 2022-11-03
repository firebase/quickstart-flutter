import 'package:authentication_quickstart/widgets/login_provider_chip.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('Firebase Auth'),
          const Text('Identity Providers'),
          LoginProviderChip(
            providerIcon: const Icon(Icons.g_mobiledata_outlined),
            providerName: 'Google',
            onClick: () => {},
          )
        ],
      ),
    );
  }
}
