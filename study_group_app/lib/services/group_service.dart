import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:study_group_app/models/groups.dart';

class GroupService {
  String userUid;

  GroupService({this.userUid});
  final CollectionReference _groupCollection =
      Firestore.instance.collection('groups');

  // Maps the snapshots from Firebase to a list of Groups
  List<Group> _grpFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Group.fromFirestore(doc);
    }).toList();
  }

  // Provides the stream of Group data to the app
  Stream<List<Group>> get groupData {
    return _groupCollection
        .where('memberIds', arrayContains: userUid)
        .snapshots()
        .map(_grpFromSnapshot);
  }

  /// Create new group in Firebase
  Future createGroup(Group newGrp) async {
    try {
      // Adds a new document to the groups collection
      // MemberIds array is created with the current user's uid
      var result = await _groupCollection.add({
        'name': newGrp.name,
        'memberIds': FieldValue.arrayUnion([userUid]),
        'maxMembers': newGrp.maxMembers,
        'day': newGrp.day,
        'startTime': newGrp.startTime,
        'endTime': newGrp.endTime,
        'location': newGrp.location,
        'course': newGrp.course,
      });
      return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  /// Searches for a group by name
  Future<List<Group>> findGroup(String searchStr) async {
    // Get results that match the 'name' field
    var nameList = await _groupCollection
        .where(
          'name',
          isGreaterThanOrEqualTo: searchStr,
          isLessThan: searchStr.substring(0, searchStr.length - 1) +
              String.fromCharCode(
                  searchStr.codeUnitAt(searchStr.length - 1) + 1),
        )
        .getDocuments()
        .then((snap) =>
            snap.documents.map((doc) => Group.fromFirestore(doc)).toList());

    // Course is stored in all uppercase so convert query to match
    searchStr = searchStr.toUpperCase();
    var courseList = await _groupCollection
        .where(
          'course',
          isGreaterThanOrEqualTo: searchStr,
          isLessThan: searchStr.substring(0, searchStr.length - 1) +
              String.fromCharCode(
                  searchStr.codeUnitAt(searchStr.length - 1) + 1),
        )
        .getDocuments()
        .then((snap) =>
            snap.documents.map((doc) => Group.fromFirestore(doc)).toList());

    nameList.addAll(courseList);
    return nameList;
  }

  /// Updates a group with the specified member
  Future updateGroupMember(String groupId, String memberId) async {
    try {
      await _groupCollection.document(groupId).setData({
        'memberIds': FieldValue.arrayUnion([memberId])
      }, merge: true);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
