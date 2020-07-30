import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorMainScreen extends StatelessWidget {
  static const routeName = '/doctor-main-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Main Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
