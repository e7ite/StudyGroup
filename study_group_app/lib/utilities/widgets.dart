import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Color buttonColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final Function onPressed;

  Button(
      {@required this.text,
      this.width = 160.0,
      this.height = 70.0,
      this.textColor = const Color(0XFF599ECA),
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
      this.buttonColor = Colors.white,
      @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 17),
      width: width,
      height: height,
      // Login button
      child: RaisedButton(
        onPressed: onPressed,
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            letterSpacing: 1.5,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }
}
