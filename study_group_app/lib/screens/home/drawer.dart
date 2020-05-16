//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/screens/student/course_viewer.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_group_app/screens/profile/profile_page.dart';
import 'package:study_group_app/screens/profile/settings_page.dart';

final Auth _auth = Auth();
bool drawer = false;

// Separate the drawer into this class so it can be called from anywhere
class MainDrawer extends StatelessWidget {
  final User user;
  MainDrawer({this.user});

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<User>(context);
    // Returns a Drawer that can be added to any Scaffold drawer
    return Drawer(
      child: ListView(
        //padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        padding: EdgeInsets.zero,
        //Further expanding objects held in the drawer
        children: <Widget>[
          // Finally at setting first item, This is the big colored chunk
          // with the header text in it in the upper half of drawer
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF77af9c)),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 70,
                    height: 70,
                    child: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.white,
                      child: FaIcon(
                        FontAwesomeIcons.solidUser,
                        //Color(0xFFc2e59c)
                        size: 48, color: Color(0xFFc2e59c),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: Column(
                      children: <Widget>[],
                    ),
                  ),
                  Text(
                    ' ${user.userName}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.class_,
                    color: Color(0xFF77af9c),
                  ),
                  title: Text(
                    'My Courses',
                    style: TextStyle(
                      color: Color(0xFF77af9c),
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseViewer(userId: user.uid),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Color(0xFF77af9c),
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Color(0xFF77af9c),
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profile(user: user),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Color(0xFF77af9c),
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Color(0xFF77af9c),
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSettings(
                          uid: user.uid,
                          auth: _auth,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 180),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Color(0xFF77af9c),
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFF77af9c),
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _auth.logOut();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //MainDrawer({this.userData});
}
