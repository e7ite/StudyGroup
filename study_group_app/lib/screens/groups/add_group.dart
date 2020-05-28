import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/groups.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/services/group_service.dart';

class CreateGroup extends StatefulWidget {
  // CreateGroup({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _CreateGroupFormState createState() => _CreateGroupFormState();
}

class _CreateGroupFormState extends State<CreateGroup> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _db = GroupService();
  TimeOfDay _startTime;
  TimeOfDay _endTime;
  String groupName;
  String day;
  int maxMembers;
  String location;
  String course;
  TextEditingController _startTimeCntrl;
  TextEditingController _endTimeCntrl;

  @override
  void initState() {
    _startTimeCntrl = TextEditingController();
    _endTimeCntrl = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _startTimeCntrl.dispose();
    _endTimeCntrl.dispose();
    super.dispose();
  }

  var selectType;
  final List<String> days = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

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

  Future<void> saveGroupToDb(context) async {
    if (validateForm()) {
      // Save group to db
      var newGroup = Group(
        name: groupName,
        day: day,
        startTime: _convertTime(_startTime),
        endTime: _convertTime(_endTime),
        maxMembers: maxMembers,
        location: location,
        course: course,
      );
      // Get current user Uid to pass into GroupProvider to create group
      var curUser = Provider.of<User>(context, listen: false);
      _db.userUid = curUser.uid;
      dynamic result = _db.createGroup(newGroup);
      if (result != null) {
        _successScaffold(context, 'Group created successfully!');
      } else {
        print('error');
      }
    }
  }

  String _convertTime(TimeOfDay time) {
    return (time.hour.toString() + ':' + time.minute.toString());
  }

  void _successScaffold(BuildContext context, _message) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    Text('Create a New Group',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                    SizedBox(height: 15),

                    // Name field
                    TextFormField(
                      onSaved: (value) {
                        groupName = value;
                      },
                      validator: (value) =>
                          value.isEmpty ? 'Please enter a group name' : null,
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.users),
                        labelText: 'Group Name',
                      ),
                    ),
                    SizedBox(height: 15),

                    TextFormField(
                      onSaved: (value) {
                        course = value.toUpperCase();
                      },
                      validator: (value) => value.isEmpty
                          ? 'Please enter a class for the group'
                          : null,
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.university),
                        labelText: 'Class',
                      ),
                    ),

                    SizedBox(height: 15),
                    // Day field
                    DropdownButtonFormField(
                      isDense: true,
                      value: selectType,
                      validator: (val) =>
                          val.isEmpty ? 'Please select a day' : null,
                      decoration: InputDecoration(
                          icon: FaIcon(FontAwesomeIcons.calendarAlt),
                          labelText: 'Day'),
                      items: days.map((value) {
                        return DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (selectDays) {
                        setState(() {
                          selectType = selectDays;
                        });
                      },
                      onSaved: (selectedDay) {
                        day = selectedDay;
                      },
                    ),
                    SizedBox(height: 15),

                    // Start time
                    TextFormField(
                      readOnly: true,
                      controller: _startTimeCntrl,
                      onTap: () async {
                        _startTime = await selectTime(context);
                        _startTimeCntrl.text = _startTime?.format(context);
                      },
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.clock),
                        labelText: 'Start Time',
                      ),
                    ),
                    SizedBox(height: 15),

                    // End time
                    TextFormField(
                      readOnly: true,
                      controller: _endTimeCntrl,
                      onTap: () async {
                        _endTime = await selectTime(context);
                        _endTimeCntrl.text = _endTime?.format(context);
                      },
                      decoration: InputDecoration(
                        icon: FaIcon(FontAwesomeIcons.solidClock),
                        labelText: 'End Time',
                      ),
                    ),
                    SizedBox(height: 15),

                    // Location
                    TextFormField(
                      onSaved: (selectedLoc) {
                        location = selectedLoc;
                      },
                      decoration: InputDecoration(
                          icon: FaIcon(FontAwesomeIcons.mapMarkedAlt),
                          labelText: 'Location'),
                    ),
                    SizedBox(height: 15),

                    // Max members
                    TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (val) {
                        maxMembers = int.parse(val);
                      },
                      decoration: InputDecoration(
                          icon: FaIcon(FontAwesomeIcons.users),
                          labelText: 'Max Group Members'),
                    ),

                    // Submit button
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 17),
                      //width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          saveGroupToDb(context);
                        },
                        //color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          'CREATE GROUP',
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
