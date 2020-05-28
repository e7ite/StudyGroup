import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/models/groups.dart';
import 'package:study_group_app/screens/groups/group_card.dart';
import 'package:study_group_app/utilities/loading.dart';

class GroupView extends StatefulWidget {
  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView> {
  // List of groups to be populated on initState

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<List<Group>>(context);
    // Main content of the card, Sets placement and content of inner objects

    // Handles the scrolling behavior and bundled up Widgets to return to caller
    if (groups != null) {
      return Container(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) {
            return GroupCard(group: groups[index]);
          },

          // May be a better way to do this, but builds a dividing space between each card
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Theme.of(context).backgroundColor,
            );
          },
        ),
      );
    } else {
      return Loading();
    }
  }
}
