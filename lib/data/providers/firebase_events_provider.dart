import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_app_flutter/data/models/base_calendar_events.dart';
import 'package:to_do_app_flutter/data/models/calendar_event.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class FirebaseEventsProvider {
  final AppUser user;
  final db = FirebaseFirestore.instance;
  late final CollectionReference<Map<String, dynamic>> baseColRef;
  late final CollectionReference<Map<String, dynamic>> additionalColRef;

  FirebaseEventsProvider({required this.user}) {
    baseColRef =
        db.collection("users").doc(user.id).collection("baseEventData");
    additionalColRef =
        db.collection("users").doc(user.id).collection("additionalEventData");
  }

  Future<List<Map<String, dynamic>>> getDayEvents(DateTime day) async {
    DateTime startDateTime = DateTime(day.year, day.month, day.day);
    DateTime endDateTime = DateTime(day.year, day.month, day.day, 23, 59, 59);

    QuerySnapshot rawData = await baseColRef
        .where("startDateTime",
            isGreaterThanOrEqualTo: startDateTime,
            isLessThanOrEqualTo: endDateTime)
        .orderBy("startDateTime")
        .get();

    List<Map<String, dynamic>> result = [];
    for (var data in rawData.docs) {
      result.add({
        "id": data["id"],
        "name": data["name"],
        "startDateTime": data["startDateTime"],
        "duration": data["duration"],
        "category": data["category"],
      });
    }

    return result;
  }

  Future<Map<String, dynamic>> readEvent(String eventId) async {
    List<DocumentSnapshot<Map<String, dynamic>>> data = await Future.wait([
      baseColRef.doc(eventId).get(),
      additionalColRef.doc(eventId).get(),
    ]);

    if (data[0].data() == null) {
      throw Exception("Cannot get base event data");
    }

    if (data[1].data() == null) {
      throw Exception("Cannot get additional event data");
    }

    return {...data[0].data()!, ...data[1].data()!};
  }

  Future<List<Map<String, dynamic>>> getCategoryEvents(
      String categoryID) async {
    QuerySnapshot<Map<String, dynamic>> snap = await baseColRef
        .where("category.id", isEqualTo: categoryID)
        //.orderBy("startDateTime")
        .get();

    return List.generate(snap.docs.length, (index) => snap.docs[index].data());
  }

  Future<List<Map<String, dynamic>>> getEventsWithoutCategory() async {
    QuerySnapshot<Map<String, dynamic>> snap = await baseColRef
        .where("category", isEqualTo: null)
        //.orderBy("startDateTime")
        .get();

    return List.generate(snap.docs.length, (index) => snap.docs[index].data());
  }

  Future<List<Map<String, dynamic>>> getEventsFromDateRange(
      DateTime startDate, DateTime endDate) async {
    DateTime fromDate =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime toDate =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    QuerySnapshot<Map<String, dynamic>> snap = await baseColRef
        .where("startDateTime",
            isGreaterThanOrEqualTo: fromDate, isLessThanOrEqualTo: toDate)
        .orderBy("startDateTime")
        .get();

    return List.generate(snap.docs.length, (index) => snap.docs[index].data());
  }

  Future<void> createEvent(Map<String, dynamic> baseEventData,
      Map<String, dynamic> additionalData) async {
    String id = baseColRef.doc().id;
    baseEventData["id"] = id;

    var futures = <Future>[
      baseColRef.doc(id).set(baseEventData),
      additionalColRef.doc(id).set(additionalData),
    ];

    await Future.wait(futures);
  }

  Future<void> deleteEvent(String eventID) async {
    await Future.wait([
      baseColRef.doc(eventID).delete(),
      additionalColRef.doc(eventID).delete(),
    ]);
  }

  Future<void> updateBaseEventData(
      Map<String, dynamic> updatedEventData) async {
    await baseColRef.doc(updatedEventData["id"]).set(updatedEventData);
  }

  Future<void> updateAdditionalEventData(
      Map<String, dynamic> updatedEventData, String eventID) async {
    await additionalColRef.doc(eventID).set(updatedEventData);
  }
}
