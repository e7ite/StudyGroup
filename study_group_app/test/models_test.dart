import 'package:study_group_app/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/firebase_mock.dart';

void main() {
  group('User class', () {
    test('User fromFirestore, full data', () {
      // Create mock DocumentSnapshots
      var userSnap = DocumentSnapshotMock();

      userSnap.mockData = Map<String, dynamic>.from({
        'userName': 'testuser',
        'email': 'testuser@gmail.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'courses': ['csci-515', 'csci-500'],
      });

      var user = User.fromFirestore(userSnap);

      expect(user.userName, 'testuser');
      expect(user.email, 'testuser@gmail.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.courses, ['csci-515', 'csci-500']);
    });

    test('User fromFirestore, missing courses', () {
      // Create mock DocumentSnapshots
      var userSnap = DocumentSnapshotMock();
      userSnap.mockData = Map<String, dynamic>.from({
        'userName': 'testuser',
        'email': 'testuser@gmail.com',
        'firstName': 'John',
        'lastName': 'Doe',
      });

      var user = User.fromFirestore(userSnap);

      // Shouldn't be any errors even if Firestore returns null for some fields
      expect(user.uid, 'uid');
      expect(user.userName, 'testuser');
      expect(user.email, 'testuser@gmail.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.courses, []);
    });
  });

  group('Group class', () {
    test('Group fromFirestore, full data', () {
      var groupSnap = DocumentSnapshotMock();

      // Mock return data from Firestore
      groupSnap.mockData = Map<String, dynamic>.from({
        'name': 'TestGroup',
        'memberIds': ['id1', 'id2', 'id3'],
        'maxMembers': 4,
        'day': 'Monday',
        'startTime': '13:00',
        'endTime': '14:30',
        'location': 'Library',
        'course': 'CSCI-500',
      });

      // Map mock data to Group instance
      var group = Group.fromFirestore(groupSnap);

      expect(group.id, 'uid');
      expect(group.name, 'TestGroup');
      expect(group.memberIds, ['id1', 'id2', 'id3']);
      expect(group.maxMembers, 4);
      expect(group.day, 'Monday');
      expect(group.startTime, '13:00');
      expect(group.endTime, '14:30');
      expect(group.location, 'Library');
      expect(group.course, 'CSCI-500');
    });

    test('Group fromFirestore, missing data', () {
      // Create Mock data from Firestore
      var groupSnap = DocumentSnapshotMock();
      groupSnap.mockData = Map<String, dynamic>.from({
        'name': 'TestGroup',
        'day': 'Monday',
      });

      var group = Group.fromFirestore(groupSnap);
      expect(group.id, 'uid');
      expect(group.name, 'TestGroup');
      expect(group.memberIds, []);
      expect(group.maxMembers, 0);
      expect(group.day, 'Monday');
      expect(group.startTime, '');
      expect(group.endTime, '');
      expect(group.location, '');
      expect(group.course, '');

      // Shouldn't be any errors even if Firestore returns null for some fields
    });
  });

  group('Message class', () {
    test('Message.fromMap, full data', () {
      var messageSnap = DocumentSnapshotMock();
      messageSnap.mockData = Map<String, dynamic>.from({
        'userEmail': 'testuser@gmail.com',
        'userName': 'usr',
        'time': 1450,
        'messageText': 'An example message',
        'groupId': 'grp1Id',
      });

      var message = Message.fromMap(messageSnap.data);
      expect(message.userEmail, 'testuser@gmail.com');
      expect(message.userName, 'usr');
      expect(message.time, 1450);
      expect(message.messageText, 'An example message');
      expect(message.groupId, 'grp1Id');
    });

    test('Message.fromFirestore, partial data', () {
      var messageSnap = DocumentSnapshotMock();
      messageSnap.mockData = Map<String, dynamic>.from({
        'userName': 'usr',
        'messageText': 'An example message',
      });

      var message = Message.fromMap(messageSnap.data);
      expect(message.userEmail, '');
      expect(message.userName, 'usr');
      expect(message.time, 0);
      expect(message.messageText, 'An example message');
      expect(message.groupId, '');
    });
  });
  group('Course class', () {
    test('Course.fromMap, full data', () {
      var courseSnap = DocumentSnapshotMock();
      courseSnap.mockData = Map<String, dynamic>.from({
        'name': 'CSCI-100',
        'description': 'description of class',
        'startTime': '12:00',
        'endTime': '13:00',
        'days': 'MWF',
      });

      var course = Course.fromMap(courseSnap.data);
      expect(course.name, 'CSCI-100');
      expect(course.description, 'description of class');
      expect(course.startTime, '12:00');
      expect(course.endTime, '13:00');
      expect(course.days, 'MWF');
    });

    test('Course.fromMap, partial data', () {
      var courseSnap = DocumentSnapshotMock();
      courseSnap.mockData = Map<String, dynamic>.from({
        'name': 'CSCI-100',
        'startTime': '13:00',
        'endTime': '13:50',
      });

      var course = Course.fromMap(courseSnap.data);
      expect(course.name, 'CSCI-100');
      expect(course.description, '');
      expect(course.startTime, '13:00');
      expect(course.endTime, '13:50');
      expect(course.days, '');
    });
  });
}
