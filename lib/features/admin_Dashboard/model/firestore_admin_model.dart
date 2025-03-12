import 'package:cloud_firestore/cloud_firestore.dart';

class FSadmin {
  String id;
  String email;

  FSadmin({
    required this.id,
    required this.email,
  });

  factory FSadmin.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FSadmin(
      id: doc.id,
      email: data['email'],
    );
  }

  Map<String, dynamic> toFirestore() => {
        "id": id,
        "email": email,
      };
}
