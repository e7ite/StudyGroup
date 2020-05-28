import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/screens/home/home.dart';
import 'package:study_group_app/screens/auth/auth_view.dart';
import 'package:study_group_app/services/user_service.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This is what keeps track of changes from main's StreamProvider
    final user = Provider.of<FirebaseUser>(context);

    if (user == null) {
      return AuthView();
    } else {
      return StreamProvider<User>.value(
        value: UserService(uid: user.uid).userData,
        child: HomePage(),
      );
    }
    // Depending on if a user is logged in or out, a different screen will be shown
  }
}
