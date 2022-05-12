import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  bool _isLoading = false;
  bool _isSigningUp = false;
  final _formKey = GlobalKey<FormState>();

  void _setIsLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<UserCredential?> _signUpWithEmailAndPassword() async {
    _setIsLoading();
    try {
      final _credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );

      await _credential.user!.updateDisplayName(
          '${_firstnameController.text} ${_lastnameController.text}');

      return _credential;
    } on FirebaseAuthException catch (e) {
      /// These are two examples of several possible error messages from
      /// FirebaseAuth. Find the [complete list of error messages here.](https://firebase.google.com/docs/auth/admin/errors)
      if (e.code == 'invalid-email') {
        // ... ask user to update email value
      }
      if (e.code == 'weak-password') {
        // ...
      }
      _setIsLoading();
      return null;
    }
  }

  Future<UserCredential?> _loginWithEmailAndPassword() async {
    _setIsLoading();

    try {
      return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ...
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Email doesn\'t exist'),
                content: const Text('Please sign up instead'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            });
      }

      /// These are two examples of several possible error messages from
      /// FirebaseAuth. Find the [complete list of error messages here.](https://firebase.google.com/docs/auth/admin/errors)
      if (e.code == 'email-doesnt-exist') {
        // tell use to sign up...
      }
      if (e.code == 'wrong password') {
        // ...
      }
      _setIsLoading();
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isSigningUp)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500.0),
                    child: TextFormField(
                      controller: _firstnameController,
                      decoration: const InputDecoration(
                        label: Text('First Name'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              if (_isSigningUp)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500.0),
                    child: TextFormField(
                      controller: _lastnameController,
                      decoration: const InputDecoration(
                        label: Text('Last Name'),
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500.0),
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      label: Text('Username'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? input) {
                      if (input == null || input.isEmpty) {
                        return 'Please enter a password.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: ElevatedButton(
                  onPressed: () async {
                    _isSigningUp
                        ? await _signUpWithEmailAndPassword()
                        : await _loginWithEmailAndPassword();

                    if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.of(context).popAndPushNamed('/');
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(_isSigningUp ? 'Sign Up' : 'Log In'),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSigningUp = true;
                  });
                },
                child: const Text('Don\'t have an account? Sign Up'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
