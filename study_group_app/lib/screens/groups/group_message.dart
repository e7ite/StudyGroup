import 'package:flutter/material.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/models/message.dart';
import 'package:provider/provider.dart';
import 'package:study_group_app/services/message_service.dart';
import 'package:study_group_app/utilities/loading.dart';
import 'package:intl/intl.dart';

class GroupMessage extends StatefulWidget {
  final String groupId;
  GroupMessage({Key key, this.groupId}) : super(key: key);

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  FocusNode _focusNode = FocusNode();
  final DateFormat _dateParser = DateFormat.yMd().add_jm();
  final TextEditingController _txt = TextEditingController();

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _txt.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var messages = Provider.of<List<Message>>(context);
    var user = Provider.of<User>(context);

    if (messages != null) {
      messages.sort((a, b) => b.time.compareTo(a.time));
    }

    return messages == null || user == null
        ? Loading()
        : Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 15.0),
                    physics: BouncingScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final isMe = messages[index].userEmail == user.email;
                      final bgColor = isMe ? Colors.blue : Colors.grey[600];
                      return _buildMessage(
                          messages[index], isMe, bgColor, Colors.black);
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                height: 70.0,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.group),
                      iconSize: 25.0,
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _txt,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (message) {
                          _saveMessageToFirebase(message, user);
                          _txt.text = '';
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        style: TextStyle(fontSize: 15.0),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: 15.0),
                          hintText: 'Enter message here...',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
  }

  void _saveMessageToFirebase(String message, User user) {
    var newMessage = Message(
      userEmail: user.email,
      userName: user.userName,
      time: DateTime.now().millisecondsSinceEpoch,
      messageText: message,
      groupId: widget.groupId,
    );

    try {
      MessageService().saveToFirebase(newMessage);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildMessage(Message msg, bool isMe, Color bgColor, Color textColor) {
    return Container(
      // Builds the text background
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      decoration: BoxDecoration(
        color: isMe ? bgColor : Colors.grey,
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      // Draws the text itself
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(isMe ? 'You said:' : '${msg?.userName} said:',
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                color: textColor,
              )),
          SizedBox(height: 4.0),
          Text(msg.messageText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              )),
          SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              Text(
                '${_dateParser.format(DateTime.fromMillisecondsSinceEpoch(msg.time))}',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
