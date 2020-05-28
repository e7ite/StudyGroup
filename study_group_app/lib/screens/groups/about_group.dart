import 'package:flutter/material.dart';
import 'package:study_group_app/models/groups.dart';

class AboutGroup extends StatelessWidget {
  final Group group;
  const AboutGroup({Key key, this.group}) : super(key: key);

  Widget _cardText(String str, Color textColor) => Row(
        children: <Widget>[
          Expanded(
            child: Align(
              child: Text(
                str,
                style: TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      color: Theme.of(context).backgroundColor,
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 32.0),
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                child: Image.network(
                  'https://www.healthcareisrael.com/images/services/students-ema-care.jpg',
                  fit: BoxFit.cover,
                  height: 200.0,
                ),
                constraints: BoxConstraints.expand(height: 200.0),
              ),
              Container(
                margin: EdgeInsets.only(top: 110.0),
                height: 110.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.transparent,
                      Theme.of(context).backgroundColor,
                    ],
                    stops: [0.0, 0.9],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(0.0, 1.0),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: <Widget>[
                _cardText('Day of session:'.toUpperCase(), Colors.black),
                _cardText('${group.day}\n', Colors.black),
                _cardText('Time of session:'.toUpperCase(), Colors.black),
                _cardText(
                    '${group.startTime} - ${group.endTime}\n', Colors.black),
                _cardText('Course ID:'.toUpperCase(), Colors.black),
                _cardText('${group.id}\n', Colors.black),
                _cardText('Max Members:'.toUpperCase(), Colors.black),
                _cardText('${group.maxMembers}\n', Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
