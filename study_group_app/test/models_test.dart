import 'package:study_group_app/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock/firebase_mock.dart';

void main() {
  group('Model classes', () {
    test('User fromFirestore', () {
      // Create mock DocumentSnapshots
      var userSnap = DocumentSnapshotMock();

      userSnap.mockData = Map<String, dynamic>.from({
        'userName': 'testuser',
        'email': 'testuser@gmail.com',
        'firstName': 'John',
        'lastName': 'Doe',
        'groups': ['list', 'of', 'groups'],
        'courses': ['csci-515', 'csci-500'],
      });

      var user = User.fromFirestore(userSnap);

      expect(user.userName, 'testuser');
      expect(user.email, 'testuser@gmail.com');
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      var grps = <String>['list', 'of', 'groups'];
      expect(user.groups, grps);
      var courses = <String>['csci-515', 'csci-500'];
      expect(user.courses, courses);
    });
  });
}
