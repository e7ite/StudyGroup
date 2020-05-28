import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/services/user_service.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:study_group_app/utilities/loading.dart';

//class ProfileSettingsPage extends StatelessWidget {
class ProfileSettings extends StatefulWidget {
  final String uid;
  final Auth auth;
  ProfileSettings({this.uid, this.auth});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Controls validation state for form fields
  final _formKey = GlobalKey<FormState>();
  final _validateKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String error = '';
  String _verifyTitle = '';
  bool loading = false;
  User user;

  // Store any changes
  String newUserName;
  String newfirstName;
  String newlastName;
  String newEmail;
  String _newPassword;
  String curPassword;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: UserService(uid: widget.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          user = snapshot.data;

          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.color,
              title: Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10.0),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: const EdgeInsets.fromLTRB(29.0, 8.0, 29.0, 16.0),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        /* ----- Edit Name ------ */
                        ListTile(
                          onTap: () {
                            // Action to edit name in Firebase
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: getNewName(),
                            );
                          },
                          title: Text(
                              '${user.firstName} ${user.lastName}'), // Grab from Firebase
                          leading: Icon(Icons.face),
                          trailing: Icon(Icons.edit),
                        ),
                        _divider(),

                        /* ----- Edit Username ------ */
                        ListTile(
                          onTap: () {
                            // Action to edit username in Firebase
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: getNewUserName(),
                            );
                          },
                          title: Text('${user.userName}'),
                          leading: Icon(Icons.verified_user),
                          trailing: Icon(Icons.edit),
                        ),
                        _divider(),

                        /* ----- Edit Email ------ */
                        ListTile(
                          onTap: () {
                            _verifyTitle = 'Verify password';
                            // Verify user & edit email in Firebase
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: validateUserForEmail(),
                            );
                          },
                          title: Text('${user.email}'), // Grab from Firebase
                          leading: Icon(Icons.email),
                          trailing: Icon(Icons.edit),
                        ),
                        _divider(),

                        /* ----- Edit Password ------ */
                        ListTile(
                          onTap: () {
                            // Action to edit password in Firebase
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: validateUserForPassword(),
                            );
                          },
                          title: Text('Change Password'), // Grab from Firebase
                          leading: Icon(Icons.lock_outline),
                          trailing: Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }

  // Styling: Divider between settings
  Container _divider() {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
    );
  }

  // Validate the form and save state
  void formValidate(int type) {
    if (_formKey.currentState.validate() ||
        _validateKey.currentState.validate()) {
      setState(() => loading = true);
      _formKey.currentState.save();
      if (type == 1) {
        sendUserNameInfo();
      } else if (type == 2) {
        sendNameInfo();
      } else if (type == 3) {
        _validateKey.currentState.save();
        if (sendEmailInfo() == null) {
          // Email couldn't be changed
          _passwordAlert(context, 'Incorrect password. Try again.');
          Navigator.pop(context);
        } else {
          _passwordAlert(context, 'Email changed successfully!');
          Navigator.pop(context);
        }
      } else if (type == 4) {
        _validateKey.currentState.save();
        if (sendPasswordInfo() == null) {
          // Password couldn't be changed
          _passwordAlert(context, 'Incorrect password. Try again.');
          Navigator.pop(context);
        } else {
          _passwordAlert(context, 'Password changed successfully!');
          Navigator.pop(context);
        }
      }
    }
  }

  /* ----- Sending information to firebase ----- */

  // Firebase: Send username changes to Firebase after fields have been validated
  Future<void> sendUserNameInfo() async {
    var string_uid = user.uid.toString();
    dynamic result = UserService(uid: string_uid).updateUserName(newUserName);
    // Output appropriate error if result is null
    if (result == null) {
      setState(() => error = 'Could not change username.');
      loading = false;
    }
  }

  // Firebase: Send name changes to Firebase after fields have been validated
  Future<void> sendNameInfo() async {
    var string_uid = user.uid.toString();
    dynamic result_firstname =
        UserService(uid: string_uid).updateFirstName(newfirstName);
    dynamic result_lastname =
        UserService(uid: string_uid).updateLastName(newlastName);
    // Output appropriate error if result is null
    if (result_firstname == null || result_lastname == null) {
      setState(() => error = 'Could not change name.');
      loading = false;
    }
  }

  // Firebase: Send email changes to Firebase after fields have been validated
  Future<void> sendEmailInfo() async {
    var string_uid = user.uid.toString();
    dynamic result =
        UserService(uid: string_uid).updateEmail(newEmail, curPassword);
    // Output appropriate error if result is null
    if (result == null) {
      setState(() => error = 'Could not change email.');
      loading = false;
    }
    return true;
  }

  // Firebase: Send email changes to Firebase after fields have been validated
  Future<void> sendPasswordInfo() async {
    var string_uid = user.uid.toString();
    dynamic result = UserService(uid: string_uid)
        .updatePassword(user.email, curPassword, _newPassword);
    //await widget.auth.changePassword(_newPassword);
    // Output appropriate error if result is null
    if (result == null) {
      setState(() => error = 'Could not change password.');
      loading = false;
    }
  }

  /* ----- Getting User Input ----- */

  // Get new username
  Widget Function(BuildContext) getNewUserName() {
    return (_) => AlertDialog(
          title: Text('Change your username'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '${user.userName}',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Enter a valid username.\n';
                }
                return null;
              },
              onSaved: (String value) {
                // Store new username value
                newUserName = value;
              },
            ),
          ),
          actions: [
            FlatButton(
                child: Text('Submit'),
                // Save new username to Firebase
                onPressed: () {
                  formValidate(1);
                  Navigator.pop(context);
                })
          ],
        );
  }

  // Get new name
  Widget Function(BuildContext) getNewName() {
    return (_) => AlertDialog(
            title: Text('Change your name'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '${user.firstName} ${user.lastName}',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter a valid first name.\n';
                  }
                  return null;
                },
                onSaved: (String value) {
                  // Parse and store new first and last name value
                  var newName = value;
                  var splitName = newName.split(' ');
                  newfirstName = splitName[0];
                  newlastName = splitName[1];
                },
              ),
            ),
            actions: [
              FlatButton(
                  child: Text('Submit'),
                  // Save new name to Firebase
                  onPressed: () {
                    formValidate(2);
                    Navigator.pop(context);
                  }),
            ]);
  }

  // Get new email
  Widget Function(BuildContext) getNewEmail() {
    print(user.email);
    return (_) => AlertDialog(
            title: Text('Change your email'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '${user.email}',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter a valid email.\n';
                  }
                  return null;
                },
                onSaved: (String value) {
                  // Store new email value
                  newEmail = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  child: Text('Submit'),
                  // Save new email to Firebase
                  onPressed: () {
                    formValidate(3);
                    Navigator.pop(context);
                  }),
            ]);
  }

  // Get new password
  Widget Function(BuildContext) getNewPassword() {
    return (_) => AlertDialog(
            title: Text('Change your password'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                obscureText: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter a valid password.\n';
                  }
                  return null;
                },
                onSaved: (String value) {
                  // Store new password value
                  _newPassword = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  child: Text('Submit'),
                  // Save new email to Firebase
                  onPressed: () {
                    formValidate(4);
                    Navigator.pop(context);
                  }),
            ]);
  }

  /* ----- Validations ----- */

  // Validate user for email change
  Widget Function(BuildContext) validateUserForEmail() {
    return (_) => AlertDialog(
            title: Text(_verifyTitle),
            content: Form(
              key: _validateKey,
              child: TextFormField(
                obscureText: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter a valid password.\n';
                  }
                  return null;
                },
                onSaved: (String value) {
                  // Store current password value for reauthentication
                  curPassword = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  child: Text('Verify'),
                  onPressed: () {
                    // Get new email
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: getNewEmail(),
                    );
                  }),
            ]);
  }

  // Validate user for password change
  Widget Function(BuildContext) validateUserForPassword() {
    return (_) => AlertDialog(
            title: Text('Verify password'),
            content: Form(
              key: _validateKey,
              child: TextFormField(
                obscureText: true,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter a valid password.\n';
                  }
                  return null;
                },
                onSaved: (String value) {
                  // Store current password value for reauthentication
                  curPassword = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                  child: Text('Verify'),
                  onPressed: () {
                    // Get new password
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: getNewPassword(),
                    );
                  }),
            ]);
  }

  // Validates an email address
  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regex = RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  /* ----- Snackbar Alerts ----- */

  void _passwordAlert(BuildContext context, _message) {
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
}
