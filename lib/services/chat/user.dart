import 'package:chat_app/services/auth/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> Block(String currentUserUid, String otherUserUid) async {
  final userDoc =
      FirebaseFirestore.instance.collection('Users').doc(currentUserUid);

  await userDoc.update({
    'block': FieldValue.arrayUnion([otherUserUid])
  });
  await removeContact(currentUserUid, otherUserUid);
  await removeContact(otherUserUid, currentUserUid);
  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .get();
  userData = doc.data()!;
}

Future<void> Unblock(String currentUserUid, String otherUserUid) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .update({
    'block': FieldValue.arrayRemove([otherUserUid])
  });
  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .get();
  userData = doc.data()!;
}

Future<void> addContact(String currentUserUid, String otherUserUid) async {
  final userDoc =
      FirebaseFirestore.instance.collection('Users').doc(currentUserUid);

  await userDoc.update({
    'contacts': FieldValue.arrayUnion([otherUserUid])
  });
  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .get();
  userData = doc.data()!;
}

Future<void> removeContact(String currentUserUid, String otherUserUid) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .update({
    'contacts': FieldValue.arrayRemove([otherUserUid])
  });
}

Future<void> addChat(String currentUserUid, String otherUserUid) async {
  final userDoc =
      FirebaseFirestore.instance.collection('Users').doc(currentUserUid);

  await userDoc.update({
    'chat': FieldValue.arrayUnion([otherUserUid])
  });
}

Future<void> removeChat(String currentUserUid, String otherUserUid) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .update({
    'chat': FieldValue.arrayRemove([otherUserUid])
  });
  final doc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .get();
  userData = doc.data()!;
}

Future<bool> isContact(String currentUserUid, String otherUserUid) async {
  // final userDoc = await FirebaseFirestore.instance
  //     .collection('Users')
  //     .doc(currentUserUid)
  //     .get();

  // final data = userDoc.data();
  // if (data != null && data['contacts'] != null) {
  //   List<dynamic> contacts = data['contacts'];
  //   return contacts.contains(otherUserUid);
  // }

  // return false;
  return (userData!['contacts'] as List).any((uid) => uid == otherUserUid);
}

Future<bool> isBlocked(String currentUserUid, String otherUserUid) async {
  
  final userDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .get();

  final data = userDoc.data();
  if (data != null && data['block'] != null) {
    List<dynamic> blocked = data['block'];
    return blocked.contains(otherUserUid);
  }

  return false;
}

Future<bool> BlockedBy(String currentUserUid, String otherUserUid) async {
  final userDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(otherUserUid)
      .get();

  final data = userDoc.data();
  if (data != null && data['block'] != null) {
    List<dynamic> blocked = data['block'];
    return blocked.contains(currentUserUid);
  }

  return false;
}
