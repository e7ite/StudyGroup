class Message {
  final String userEmail;
  final String userName;
  final int time;
  final String messageText;
  final String groupId;

  Message(
      {this.userEmail,
      this.userName,
      this.time,
      this.messageText,
      this.groupId});

  factory Message.fromMap(Map map) {
    return Message(
      userEmail: map['userEmail'] ?? '',
      userName: map['userName'] ?? '',
      time: map['time'] ?? 0,
      messageText: map['messageText'] ?? '',
      groupId: map['groupId'] ?? '',
    );
  }
}
