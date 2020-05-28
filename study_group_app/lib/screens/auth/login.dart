import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_group_app/utilities/utilities.dart';
import 'package:study_group_app/services/auth.dart';

// Stateful Login Page Class
class LoginPage extends StatefulWidget {
  // Gives us a control on switching to login page. We can call this function locally
  // which calls the registerOrSignIn function from auth_view.dart
  final Function view;
  LoginPage({this.view});
  // Creates the stateful widget LoginPage
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form key to validate user entry
  final _formKey = GlobalKey<FormState>();

  // Instance of Auth to call Firebase sign in authentication functions
  final Auth _auth = Auth();

  // Local variables to store email, password, and error
  String email;
  String password;
  String error = '';
  bool loading = false;

  // Holds the state of the forms
  bool _validateState = false;

  Future<void> sendLoginInfo() async {
    dynamic result = await _auth.signInUserWithEmail(email, password);
    if (result == null) {
      setState(() => error = 'Wrong email or password');
      loading = false;
    }
  }

  // Main build function, generates the view
  @override
  Widget build(BuildContext context) {
    // Scaffold is from MaterialApp. Implements the basic visual layout
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0XFF64b3f4),
                        Color(0xFFc2e59c),
                      ],
                    ),
                  ),
                ),
                // Container: UI for Login Form
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                    child: Form(
                      key: _formKey,
                      autovalidate: _validateState,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 50),
                          Text(
                            'Login Information',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  icon: FaIcon(FontAwesomeIcons.envelope),
                                  labelText: 'Email Address',
                                ),
                                validator: Validations.instance.emailValidation,
                                onSaved: (String val) {
                                  email = val;
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 30),
                          // Password field - actual typed letters are hidden
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: FaIcon(FontAwesomeIcons.lock),
                            ),
                            obscureText: true,
                            onSaved: (String val) {
                              password = val;
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Button(
                            onPressed: formValidate,
                            width: 280.0,
                            fontSize: 18.0,
                            text: 'LOGIN',
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                ' - OR - ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 30),
                              RichText(
                                text: TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: 'Sign Up!',
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
                              Text(
                                error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  // Will validate both forms when submit button is pressed
  void formValidate() {
    if (_formKey.currentState.validate()) {
      // Set loading widget
      setState(() => loading = true);

      // Save form details and call send information to auth service
      _formKey.currentState.save();
      sendLoginInfo();
    } else {
      setState(() => _validateState = true);
    }
  }
}
