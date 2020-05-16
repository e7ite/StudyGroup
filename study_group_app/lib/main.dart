import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:study_group_app/services/services.dart';
import 'package:study_group_app/utilities/style.dart';
import 'package:study_group_app/screens/wrapper.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Auth().getUser,
      child: MaterialApp(
        title: 'Study Buddy',
        // Importing from theme/style.dart
        theme: themeData,
        // Allows navigation to determine what to display
        // home: BottomNavBar(),
        home: Wrapper(),
        // onGenerateRoute: Routes.generateRoute,
        // initialRoute: '/',
      ),
    );
  }
}
