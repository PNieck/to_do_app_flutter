import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class FirebaseCategoriesProvider {
  final AppUser user;
  final db = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> colRef;

  FirebaseCategoriesProvider(this.user) {
    colRef = db.collection("users").doc(user.id).collection("eventCategories");
  }

  Future<List<Map<String, Object>>> getCategories() async {
    QuerySnapshot querySnapshot = await colRef.get();

    List<Map<String, Object>> result = [];

    for (var doc in querySnapshot.docs) {
      result.add({
        "id": doc["id"],
        "name": doc["name"],
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> getSingleCategory(String categoryID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await colRef.doc(categoryID).get();

    if (snapshot.data() == null) {
      throw Exception("Cannot fetch category");
    }

    return snapshot.data()!;
  }

  Future<void> createCategory(Map<String, Object> categoryData) async {
    final docRef =
        db.collection("users").doc(user.id).collection("eventCategories").doc();

    categoryData["id"] = docRef.id;

    await docRef.set(categoryData);
  }

  Future<void> updateCategory(Map<String, Object> categoryData) async {
    await db
        .collection("users")
        .doc(user.id)
        .collection("eventCategories")
        .doc(categoryData["id"].toString())
        .set(categoryData);
  }
}
