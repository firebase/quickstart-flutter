import 'package:dataconnect/util/auth.dart';
import 'package:flutter/material.dart';

class LoginGuard extends StatelessWidget {
  const LoginGuard({
    super.key,
    required this.widgetToGuard,
    this.message,
  });

  final Widget widgetToGuard;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth.isLoggedIn(),
      builder: (context, state) {
        final isLoggedIn = state.data ?? false;
        if (!isLoggedIn) {
          if (message == null) {
            return const SizedBox();
          }
          return Text(
            'Please visit the profile page'
            'to log in before $message',
          );
        }
        return widgetToGuard;
      },
    );
  }
}
