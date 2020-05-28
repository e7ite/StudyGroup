// /* COURSES: Simply displays what the student's current schedule is.
//  * This could be useful for:
//  *  - Keeping a history of user's previously classes
//  *  - Saving data for study group matching
//  *  - For future use, can be moved to instead open from user's profile
//  *    as a way for users to see what other users are taking/taken.
//  */

import 'package:flutter/material.dart';
import 'package:study_group_app/models/course.dart';
import 'package:study_group_app/services/user_service.dart';
import 'package:study_group_app/utilities/utilities.dart';

import 'add_courses.dart';

class CourseViewer extends StatefulWidget {
  final String userId;
  CourseViewer({this.userId});

  @override
  _CourseViewerState createState() => _CourseViewerState();
}

class _CourseViewerState extends State<CourseViewer> {
  var courses;
  @override
  void initState() {
    super.initState();
    _initUserCourses();
  }

  Future _initUserCourses() async {
    var tmp = await UserService(uid: widget.userId).getUserCourses();
    setState(() {
      courses = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return courses == null
        ? Loading()
        : DefaultTabController(
            length: courses.length,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text('Courses'),
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    for (final tab in courses) Tab(text: tab.name),
                  ],
                ),
              ),
              body: courses.length == 0
                  ? _addCoursesButton(context)
                  : TabBarView(
                      children: [
                        for (final tab in courses)
                          Center(child: getContent(tab, context)),
                      ],
                    ),
            ),
          );
  }

  Widget _addCoursesButton(context) {
    return Center(
      child: Button(
        text: 'ADD CLASSES',
        buttonColor: Colors.grey[300],
        textColor: Color(0xFF98c1d9),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddCourses(userId: widget.userId)),
          );
        },
      ),
    );
  }

  Container getContent(Course course, context) {
    return Container(
      child: Column(
        children: <Widget>[
          getTitle(course.name),
          getTime(course, context),
          getDays(course.days, context),
          getDescription(course.description, context),
        ],
      ),
    );
  }

  Container getDescription(String description, context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.topCenter,
      child: Text(description, style: Theme.of(context).textTheme.bodyText2),
    );
  }

  Container getDays(String days, context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1,
          children: <TextSpan>[
            TextSpan(
              text: 'Days: ',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: days, style: Theme.of(context).textTheme.bodyText1),
          ],
        ),
      ),
    );
  }

  Container getTime(Course course, context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      alignment: Alignment.topLeft,
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.subtitle1,
          children: <TextSpan>[
            TextSpan(
              text: 'Meet Time:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              text:
                  ' ${Utility.strToTimeOfDay(course.startTime).format(context).toString()} - '
                  '${Utility.strToTimeOfDay(course.endTime).format(context).toString()}',
            ),
          ],
        ),
      ),
    );
  }

  Container getTitle(String title) {
    return Container(
      padding: EdgeInsets.all(20.0),
      alignment: Alignment.topCenter,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
