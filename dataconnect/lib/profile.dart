import 'package:dataconnect/main.dart';
import 'package:dataconnect/util/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _currentUser;
  @override
  void initState() {
    super.initState();
    Auth.getCurrentUser().then((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Widget _UserInfo() {
    return Container(
      child: Column(
        children: [
          Text('Welcome back ${_currentUser!.displayName ?? ''}!'),
          TextButton(
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                context.go('/login');
              },
              child: Text('Sign out'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _currentUser == null
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [CircularProgressIndicator()],
          )
        : Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [_UserInfo()],
            ),
          );
  }
}
