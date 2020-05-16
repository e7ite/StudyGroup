import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_group_app/models/course.dart';
import 'package:study_group_app/services/user_service.dart';

// Stateful course schedule page class.
class AddCourses extends StatefulWidget {
  AddCourses({Key key, this.userId}) : super(key: key);
  final String userId;

  @override
  // Creates the stateful widget HomePage
  _MyCourseFormState createState() => _MyCourseFormState();
}

// Inherits from CourseSchedulePage above
class _MyCourseFormState extends State<AddCourses> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Form controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController daysController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController descController = TextEditingController();

  // Form data
  // TimeOfDay _dateTime;
  TimeOfDay _startTime;
  TimeOfDay _endTime;

  @override
  void dispose() {
    nameController.dispose();
    daysController.dispose();
    endTimeController.dispose();
    startTimeController.dispose();
    super.dispose();
  }

  Future<TimeOfDay> selectTime(context) async {
    final _timePicked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (_timePicked != null) {
      return _timePicked;
    }
    return null;
  }

  bool validateForm() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      return true;
    }
    return false;
  }

  Future<void> saveCourseToDb(context) async {
    if (validateForm()) {
      var course = Course(
        name: nameController.text.toUpperCase(),
        startTime: _convertTime(_startTime),
        endTime: _convertTime(_endTime),
        days: daysController.text,
        description: descController.text,
      );
      var result = await UserService(uid: widget.userId).addCourse(course);

      if (result != null) {
        _msgScaffold(context, 'Class saved successfully!');
        nameController.clear();
        startTimeController.clear();
        endTimeController.clear();
        daysController.clear();
        descController.clear();
      } else {
        _msgScaffold(context, 'Error saving class');
      }
    }
  }

  void _msgScaffold(BuildContext context, _message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          children: <Widget>[
            Text(_message),
          ],
        ),
      ),
    );
  }

  String _convertTime(TimeOfDay time) {
    return (time.hour.toString() + ':' + time.minute.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add a course'),
      ),
      backgroundColor: Color(0xFF98c1d9),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Text(
                      'Create a Course Schedule',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: nameController,
                      validator: (value) =>
                          value.isEmpty ? 'Enter a course name' : null,
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.pencilAlt),
                        labelText: 'Course Name',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: daysController,
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.calendarDay),
                        labelText: 'Days',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      readOnly: true,
                      controller: startTimeController,
                      onTap: () async {
                        _startTime = await selectTime(context);
                        startTimeController.text = _startTime?.format(context);
                      },
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.clock),
                        labelText: 'Start Time',
                      ),
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      readOnly: true,
                      controller: endTimeController,
                      onTap: () async {
                        _endTime = await selectTime(context);
                        endTimeController.text = _endTime?.format(context);
                      },
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.solidClock),
                        labelText: 'End Time',
                      ),
                    ),
                    TextFormField(
                      controller: descController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxLength: 250,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        icon: FaIcon(FontAwesomeIcons.solidCommentAlt),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 17),
                      //width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          saveCourseToDb(context);
                        },
                        //color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'ADD CLASS',
                          style: TextStyle(
                            color: Color(0xFF98c1d9),
                            letterSpacing: 1.5,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
