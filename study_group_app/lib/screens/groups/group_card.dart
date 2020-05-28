import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/groups.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/screens/groups/group_detail.dart';

import 'package:study_group_app/utilities/loading.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  GroupCard({this.group});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    return user == null
        ? Loading()
        : Container(
            height: 120.0,
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.40),
                  blurRadius: 5,
                  offset: Offset(0, 10.0),
                ),
              ],
            ),
            // Wrap InkWell in Material Widget to show the splash effect on tap
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // Call the group_detail page to view
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          GroupDetail(userId: user.uid, group: group),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(50.0, 16.0, 16.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(height: 5.0),
                      // Following Widgets are contents of each user's group.
                      Text(group.name,
                          style: Theme.of(context).textTheme.subtitle1),
                      Container(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          height: 1.5,
                          width: 40.0,
                          color: Colors.grey),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(group.day),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(child: Text(group.startTime)),
                          Expanded(
                            child: Text('Members: ${group.maxMembers}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

    // Design of outer container, shape, height, on tap functions, ect
  }
}
