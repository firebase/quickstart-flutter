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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? _user;
  String uid = "";

  @override
  void initState() {
    // Detect when a user signs in (or out, when sign out is implemented)
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _user = FirebaseAuth.instance.currentUser!;
          uid = _user!.uid;
        });
      } else {
        if (this.mounted) {
          setState(() {
            _user = null;
            uid = "";
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(uid),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _user != null
            ? Text('Welcome ${_user?.displayName}')
            : const Text('Welcome'),
      ),
      body: _user != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    "User Info:\nEmail: ${_user?.email}\nId: ${_user?.uid}\nDisplayName: ${_user?.displayName}"),
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).pushNamed('/profile'),
                        },
                    child: const Text('Proflie Screen'))
              ],
            )
          : const Center(
              child: Text('No user detected'),
            ),
    );
  }
}
