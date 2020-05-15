import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:study_group_app/models/user.dart';
import 'package:study_group_app/services/auth.dart';
import 'package:study_group_app/services/services.dart';
import 'mock/firebase_mock.dart';
import 'mock/mock_data.dart';

void main() {
  group('Auth test', () {
    final firebaseAuthMock = FirebaseAuthMock();
    final firebaseUserMock = FirebaseUserMock();
    final authResult = AuthResultMock();
    final auth = Auth(auth: firebaseAuthMock);
    // final collectionRefMock = CollectionReferenceMock();
    // final userService =
    //     UserService(uid: 'uid', userCollection: collectionRefMock);
    // final firestoreMock = FireStoreMock();

    // Mock functions provided by Auth
    test('sign in with user name and password', () async {
      when(firebaseAuthMock.signInWithEmailAndPassword(
              email: 'testuser@gmail.com', password: 'password'))
          .thenAnswer((_) => Future<AuthResultMock>.value(authResult));
      when(firebaseAuthMock.currentUser())
          .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));

      expect(await auth.signInUserWithEmail('testuser@gmail.com', 'password'),
          authResult.user);
    });

    // test('register new user', () async {
    //   when(firebaseAuthMock.createUserWithEmailAndPassword(
    //           email: 'testuser@gmail.com', password: 'password'))
    //       .thenAnswer((_) => Future<AuthResultMock>.value(authResult));
    //   when(firebaseAuthMock.currentUser())
    //       .thenAnswer((_) => Future<FirebaseUserMock>.value(firebaseUserMock));
    //   when(firestoreMock.collection('users')).thenReturn(collectionRefMock);
    //   when(collectionRefMock.document('uid').setData({
    //     'email': user.email,
    //     'userName': user.userName,
    //     'firstName': user.firstName,
    //     'lastName': user.lastName
    //   })).thenAnswer((realInvocation) => null);
    //   when(userService.createUser(user))
    //       .thenAnswer((_) => Future<void>.value(_));

    //   expect(await auth.registerNewUser('testuser@gmail.com', 'password', user),
    //       true);
    // });
  });
}
