import 'package:study_group_app/models/models.dart';

List<dynamic> courses = ['CSCI-515', 'CSCI-550'];

final user = User(
  courses: courses,
  uid: 'uid',
  userName: 'username',
  firstName: 'john',
  lastName: 'doe',
);

final testGroup = Group(
  name: 'TestGroup',
  memberIds: ['id1', 'id2', 'id3'],
  maxMembers: 4,
  day: 'Monday',
  startTime: '13:00',
  endTime: '14:30',
  location: 'Library',
  course: 'CSCI-500',
);
