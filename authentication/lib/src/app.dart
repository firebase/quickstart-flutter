// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) {
          return SignInScreen(
            actions: [
              ForgotPasswordAction(
                (context, email) {
                  Navigator.of(context).pushNamed(
                    '/forgot-password',
                    arguments: email,
                  );
                },
              ),
              AuthStateChangeAction(
                (context, state) {
                  if (state is UserCreated || state is SignedIn) {
                    var user = (state is SignedIn)
                        ? state.user
                        : (state as UserCreated).credential.user;
                    if (user == null) {
                      return;
                    }
                    if (!user.emailVerified && (state is UserCreated)) {
                      user.sendEmailVerification();
                    }
                    if (state is UserCreated) {
                      if (user.displayName == null && user.email != null) {
                        var defaultDisplayName = user.email!.split('@')[0];
                        user.updateDisplayName(defaultDisplayName);
                      }
                    }
                    // We replace the current route with the home page
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home',
                      (_) => false,
                    );
                  }
                },
              ),
            ],
          );
        },
        '/forgot-password': (context) {
          final email = ModalRoute.of(context)?.settings.arguments as String;
          return ForgotPasswordScreen(
            email: email,
            headerMaxExtent: 200,
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            appBar: AppBar(title: const Text('Profile')),
            providers: const [],
            actions: [
              SignedOutAction(
                (context) {
                  // We handle routing back to the login page in HomePage
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
        '/home': (context) => const HomePage(),
      },
    );
  }
}
