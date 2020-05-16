import 'package:firebase_auth/firebase_auth.dart';
import 'package:study_group_app/services/user_service.dart';

class Auth {
  // Create a local instance of our Firebase authentication instance
  FirebaseAuth auth = FirebaseAuth.instance;

  // Constructor to inject test Auth
  Auth({this.auth});
  // Provides a stream to continually update user data from Firebase
  Stream<FirebaseUser> get getUser {
    return auth.onAuthStateChanged;
  }

  Future signInUserWithEmail(String email, String password) async {
    try {
      // Attempt to sign in user to Firebase
      var result = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Get the Firebase User object back
      var user = result.user;

      // Convert Firebase User to local user object
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<dynamic> registerNewUser(
      String email, String password, var userdata) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var newUser = result.user;

      // Create a new document in Firebase with the same uid
      await UserService(uid: newUser.uid).createUser(userdata);
      return true;
    } catch (e) {
      print(e.toString());
      return e.message;
    }
  }

  Future<int> changeFirebaseUserEmail(String email, String curPass) async {
    var user = await auth.currentUser();
    // Reauthenticate user before changing the email
    var credential = EmailAuthProvider.getCredential(
        email: user.email, password: curPass.trim());
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (error) {
      print('Couldnt reauthenticate user.');
      print(error.toString());
      return null;
    }

    try {
      await user.updateEmail(email);
    } catch (e) {
      print(e.toString());
      return null;
    }

    // Return 1 if all checks pass
    return 1;
  }

  Future<int> changePassword(String curPassword, String newPassword) async {
    // Create an instance of the current user.
    var user = await auth.currentUser();
    // Reauthenticate user before changing password
    var credential = EmailAuthProvider.getCredential(
        email: user.email, password: curPassword.trim());
    try {
      await user.reauthenticateWithCredential(credential);
    } catch (error) {
      print('Couldnt reauthenticate' + error);
      return null;
    }

    // Pass in the password to updatePassword.
    await user.updatePassword(newPassword).then((_) {
      print('Succesfully changed password');
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
    });

    // Return 1 if all checks pass
    return 1;
  }

  Future logOut() async {
    return await auth.signOut();
  }
}
