import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:study_group_app/utilities/utilities.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Register extends StatefulWidget {
  // Gives us a control on switching to login page. We can call this function locally
  // which calls the registerOrSignIn function from auth_view.dart
  final Function view;
  Register({this.view});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Controls validation state for form fields
  final _formKey = GlobalKey<FormState>();

  // Local variables
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool loading = false;
  bool _validateState = false;
  String error = '';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: kBoxGradient,
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 27),
                    child: Form(
                      key: _formKey,
                      autovalidate: _validateState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 50),
                          Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30),
                          Column(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.white,
                                child: FaIcon(FontAwesomeIcons.solidUser,
                                    size: 57, color: Colors.grey[800]),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  icon: FaIcon(FontAwesomeIcons.envelope),
                                  labelText: 'Enter an email to register',
                                ),
                                validator: (val) {
                                  return Validations.instance
                                      .emailValidation(val);
                                },
                                onChanged: (String val) {
                                  _email.text = val.trim();
                                },
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Enter a password',
                                  icon: FaIcon(FontAwesomeIcons.lock),
                                ),
                                obscureText: true,
                                validator: (val) =>
                                    Validations.instance.password(val),
                                onChanged: (String val) {
                                  _password.text = val.trim();
                                },
                              ),
                              SizedBox(height: 30),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  icon: FaIcon(FontAwesomeIcons.lock),
                                ),
                                obscureText: true,
                                validator: (val) {
                                  if (_password.text != _confirmPass.text) {
                                    return 'Passwords don\'t match';
                                  } else {
                                    return Validations.instance.password(val);
                                  }
                                },
                                onChanged: (String val) {
                                  _confirmPass.text = val.trim();
                                },
                              ),
                            ],
                          ),
                          Button(
                            text: 'REGISTER',
                            fontSize: 18.0,
                            width: 280.0,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPageTwo(
                                        _email.text, _password.text),
                                  ),
                                );
                              } else {
                                setState(() {
                                  _validateState = true;
                                });
                              }
                            },
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(fontSize: 16),
                              children: [
                                TextSpan(
                                  text: 'Log In!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      widget.view();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

class RegisterPageTwo extends StatefulWidget {
  final String _email;
  final String _pass;
  const RegisterPageTwo(this._email, this._pass);

  @override
  _RegisterPageTwoState createState() => _RegisterPageTwoState();
}

class _RegisterPageTwoState extends State<RegisterPageTwo> {
  // Instance of Auth class that talks to Firebase
  final _auth = Auth();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // Temp variables to hold user data
  String _firstName;
  String _lastName;
  String _userName;

  /// Validates the form
  bool formValidate() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }

  /// This function sends the registration information to Firebase, after fields have been validated.
  Future<void> sendRegistrationInfo(context) async {
    setState(() => _loading = true);
    if (formValidate()) {
      var user = User(
          firstName: _firstName,
          lastName: _lastName,
          userName: _userName,
          email: widget._email);
      dynamic result =
          await _auth.registerNewUser(widget._email, widget._pass, user);

      // If auth registration successful, create new user collection
      if (result == true) {
        print('Registration successful');

        // Pop all the registration pages off the navigation stack. User will be redirected to Home
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        setState(() {
          _loading = false;
        });
        _error(context, result);
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  void _error(context, String errorMsg) {
    Alert(
      context: context,
      type: AlertType.error,
      title: errorMsg,
      desc: 'Please fix the error',
      buttons: [
        DialogButton(
          child: Text('Ok'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(),
            body: Stack(
              children: <Widget>[
                Container(decoration: kBoxGradient),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 27),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Enter information',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              TextFormField(
                                onSaved: (val) => _firstName = val.trim(),
                                validator: (val) => val.isEmpty
                                    ? 'Please enter a first name'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                ),
                              ),
                              TextFormField(
                                onSaved: (val) => _lastName = val.trim(),
                                validator: (val) => val.isEmpty
                                    ? 'Please enter a last name'
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                ),
                              ),
                              TextFormField(
                                onSaved: (val) => _userName = val.trim(),
                                validator: (val) {
                                  return Validations.instance
                                      .userNameValidation(val);
                                },
                                decoration: InputDecoration(
                                  labelText: 'User Name',
                                ),
                              ),
                            ],
                          ),
                          Button(
                            onPressed: () => sendRegistrationInfo(context),
                            text: 'Continue',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
