import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addContact(String currentUserUid, String contactUid) async {
  final userDoc =
      FirebaseFirestore.instance.collection('Users').doc(currentUserUid);

  await userDoc.update({
    'contacts': FieldValue.arrayUnion([contactUid])
  });
}

Future<void> removeContact(String currentUserUid, String contactUid) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .update({
    'contacts': FieldValue.arrayRemove([contactUid])
  });
}
Future<void> addChat(String currentUserUid, String contactUid) async {
  final userDoc =
      FirebaseFirestore.instance.collection('Users').doc(currentUserUid);

  await userDoc.update({
    'chat': FieldValue.arrayUnion([contactUid])
  });
}

Future<void> removeChat(String currentUserUid, String contactUid) async {
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .update({
    'chat': FieldValue.arrayRemove([contactUid])
  });
}
Future<bool> isContact(String currentUserUid, String contactUid) async {
  final userDoc = await FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserUid)
      .get();

  if (userDoc.exists) {
    final data = userDoc.data();
    if (data != null && data['contacts'] != null) {
      List<dynamic> contacts = data['contacts'];
      return contacts.contains(contactUid);
    }
  }
  return false;
}
