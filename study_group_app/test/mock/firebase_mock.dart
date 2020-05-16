import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:study_group_app/services/services.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class AuthResultMock extends Mock implements AuthResult {}

class AuthMock extends Mock implements Auth {}

class MockGroupProvider extends Mock implements GroupService {}

class MockUserService extends Mock implements UserService {}

class FirebaseUserMock extends Mock implements FirebaseUser {
  @override
  String get displayName => 'John Doe';
  @override
  String get uid => 'uid';
  @override
  String get email => 'testuser@gmail.com';
}

class CollectionReferenceMock extends Mock implements CollectionReference {}

class FireStoreMock extends Mock implements Firestore {}

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  Map mockData = <String, dynamic>{};
  DocumentSnapshotMock({this.mockData});
  set data(Map data) => mockData = data;
  @override
  Map<String, dynamic> get data => mockData;
  @override
  bool get exists => true;
  @override
  String get documentID => 'uid';
}
