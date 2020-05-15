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

      expect(user.uid, 'uid');
      expect(user.userName, 'testuser');
      expect(user.email, 'testuser@gmail.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.courses, []);
    });
  });

  group('Group class', () {
    test('Group fromFirestore', () {
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
  });
}
