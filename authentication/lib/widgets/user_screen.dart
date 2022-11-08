import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const Text('No user authenticated');
    }
    var uid = 'no uid';
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ignore: todo
          // TODO(@nohe427): Eventually replace this with sliverAppBar
          // https://api.flutter.dev/flutter/material/SliverAppBar-class.html
          const Text('User'),
          const Text('Info'),
          Text('UID : $uid'),
        ],
      ),
    );
  }
}
