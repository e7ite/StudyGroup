import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:study_group_app/models/groups.dart';
import 'package:study_group_app/services/group_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FindGroup extends StatelessWidget {
  final curUserId;
  FindGroup({this.curUserId});
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<Group>> _search(String search) async {
    await Future.delayed(Duration(seconds: 2));
    var result = await GroupService().findGroup(search);

    // Remove each group from the list that is at max capacity or the user is already in
    return result
        .where((f) =>
            f.memberIds.length <= f.maxMembers &&
            !(f.memberIds.contains(curUserId)))
        .toList();
  }

  TimeOfDay _convert(String time) {
    var formatTime = time.split(':');
    return TimeOfDay(
        hour: int.parse(formatTime[0]), minute: int.parse(formatTime[1]));
  }

  void _joinGroup(context, String userId, Group group) {
    var result = GroupService().updateGroupMember(group.id, userId);
    if (result == null) {
      _scaffoldMsg(context, "ERROR: Couldn't join group");
    } else {
      _scaffoldMsg(context, 'Successfully joined group ${group.name}');
    }
  }

  void _scaffoldMsg(BuildContext context, _message) {
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

  void _confirmJoinGroup(context, String userId, Group group) {
    var group2 = group;
    Alert(
      context: context,
      type: AlertType.info,
      title: 'Join group ${group2.name}?',
      buttons: [
        DialogButton(
            child: Text('Join'),
            onPressed: () {
              _joinGroup(context, userId, group);
              Navigator.pop(context);
            }),
        DialogButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ).show();
  }

  void _groupInformation(context, Group group) {
    // Reusable alert style
    var alertStyle = AlertStyle(
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
        descStyle: TextStyle(fontSize: 14.0),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: Theme.of(context).textTheme.headline5,
        constraints: BoxConstraints.expand(width: 400));

    // Alert dialog using custom alert style
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.none,
      title: 'Details for ${group.name}',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Day: ${group.day}',
              style: Theme.of(context).textTheme.subtitle1),
          Padding(padding: EdgeInsets.only(top: 2.0)),
          Text('Class: ${group.course}',
              style: Theme.of(context).textTheme.subtitle1),
          Padding(padding: EdgeInsets.only(top: 2.0)),
          Text('Meet time: ${_convert(group.startTime).format(context)}',
              style: Theme.of(context).textTheme.subtitle1),
          Padding(padding: EdgeInsets.only(top: 2.0)),
          Text('Members: ${group.memberIds.length}/${group.maxMembers}',
              style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color(0XFF64b3f4),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }

  Widget _groupResults(context, Group group) {
    return Center(
      child: Container(
        width: 250,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.users),
                title: Text(
                  group.name,
                ),
                subtitle: Text(
                  'Members: ${group.memberIds.length} / ${group.maxMembers}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    color: Colors.blue,
                    icon: FaIcon(FontAwesomeIcons.userPlus),
                    onPressed: () async {
                      await _confirmJoinGroup(context, curUserId, group);
                    },
                  ),
                  IconButton(
                    color: Colors.blue,
                    icon: FaIcon(FontAwesomeIcons.infoCircle),
                    onPressed: () {
                      _groupInformation(context, group);
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<Group>(
            key: Key('SearchBar'),
            hintText: 'Search for a group...',
            onSearch: _search,
            onItemFound: (Group grp, int index) {
              return _groupResults(context, grp);
            },
            emptyWidget: Text('No groups found with that name'),
            searchBarStyle: SearchBarStyle(
              backgroundColor: Colors.white70,
              borderRadius: BorderRadius.circular(12.0),
              // padding: EdgeInsets.all(5),
            ),
          ),
        ),
      ),
    );
  }
}
