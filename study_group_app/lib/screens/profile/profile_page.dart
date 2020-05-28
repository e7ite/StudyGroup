import 'package:flutter/material.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/screens/profile/settings_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_group_app/screens/student/add_courses.dart';
import 'package:study_group_app/screens/student/course_viewer.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:study_group_app/utilities/widgets.dart';

class Profile extends StatelessWidget {
  final User user;
  final _auth = Auth();
  Profile({this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent appbar for settings
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).appBarTheme.color,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert, size: 40.0),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileSettings(
                            uid: user.uid,
                            auth: _auth,
                          )));
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,

      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 125.0,
                width: 125.0,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  child: FaIcon(FontAwesomeIcons.solidUser,
                      size: 90, color: Colors.white),
                ),
              ),

              SizedBox(
                height: 25.0,
              ),

              // Retrieve username from Firestore
              Text(
                '${user.firstName} ${user.lastName}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),

              SizedBox(
                height: 20.0,
              ),

              // Default school
              Text(
                'California State University, Chico',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),

              // View classes
              Button(
                text: 'ADD CLASSES',
                buttonColor: Colors.grey[300],
                textColor: Color(0xFF98c1d9),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCourses(userId: user.uid)),
                  );
                },
              ),
              if (user.courses.isNotEmpty) ...[
                Button(
                  buttonColor: Colors.grey[300],
                  text: 'VIEW CLASSES',
                  textColor: Color(0xFF98c1d9),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CourseViewer(
                          userId: user.uid,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
