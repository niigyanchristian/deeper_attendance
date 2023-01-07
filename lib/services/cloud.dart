import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/app.dart';
import '../models/cloud.dart';
import '../models/local.dart';

class Cloud {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final String? uid;
  final String? localID;
  final String? regionID;
  final String? divisionID;
  final String? groupID;

  Cloud({this.uid, this.localID, this.regionID, this.divisionID, this.groupID});

  Future addUser(String uid, String username) async =>
      await db.collection('users').doc(uid).set({
        'username': username,
        'uid': uid,
        "profile": ["personal", "location", "work", "other"],
      });

  Future addAdmin(String uid, String username, String profile, String position,
          String? areaID, String? area, List others) async =>
      await db.collection('admins').doc(uid).set({
        'username': username,
        'uid': uid,
        "profile": profile,
        "position": position,
        "areaID": areaID,
        "area": area,
        "others": others,
      });

  Future<ProcessInfo> addRegion(String name, String? creator) async {
    try {
      await db
          .collection("regions")
          .add({"name": name, "creator": creator, "regionID": ""}).then((doc) =>
              db
                  .collection("regions")
                  .doc(doc.id)
                  .update({"regionID": doc.id}));
      return ProcessInfo(status: "success");
    } on FirebaseException catch (error) {
      return ProcessInfo(status: "failed", error: error);
    }
  }

  Future<ProcessInfo> addDivision(
      String name, String? regionID, String? creator) async {
    try {
      await db.collection("divisions").add({
        "name": name,
        "regionID": regionID,
        "creator": creator,
        "divisionID": ""
      }).then((doc) => db
          .collection("divisions")
          .doc(doc.id)
          .update({"divisionID": doc.id}));
      return ProcessInfo(status: "success");
    } on FirebaseException catch (error) {
      return ProcessInfo(status: "failed", error: error);
    }
  }

  Future<ProcessInfo> addGroup(
      String name, String? divisionID, String regionID, String? creator) async {
    try {
      await db.collection("groups").add({
        "name": name,
        "regionID": regionID,
        "divisionID": divisionID,
        "groupID": "",
        "creator": creator,
      }).then((doc) =>
          db.collection("groups").doc(doc.id).update({"groupID": doc.id}));
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }

  Future<ProcessInfo> addLocal(String name, String? groupID, String divisionID,
      String regionID, String? creator) async {
    try {
      await db.collection("locals").add({
        "name": name,
        "groupID": groupID,
        "divisionID": divisionID,
        "regionID": regionID,
        "localID": "",
        "creator": creator,
      }).then((doc) =>
          db.collection("locals").doc(doc.id).update({"localID": doc.id}));
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }

  Future<ProcessInfo> input({
    required List adults,
    required List youth,
    required List children,
    required int newcomers,
    required List offerings,
    required List sermon,
    String? remarks,
    required CurrentUser user,
    String? month,
    String? year,
    required int attendants,
    required String service,
    required DateTime today,
    required bool isNotYear,
  }) async {
    try {
      await db.collection("services").add({
        "adults": adults,
        "youth": youth,
        "children": children,
        "newcomers": newcomers,
        "offerings": offerings,
        "sermon": sermon,
        "remarks": remarks,
        "regionID": user.others![0],
        "divisionID": user.others![2],
        "groupID": user.others![4],
        "localID": user.areaID,
        "month": month,
        "year": year,
        "attendants": attendants,
        "review": false,
        "datetime": Timestamp.fromDate(today),
        "service": service,
        "addedBy": user.username,
        "reviewedBy": "",
        "reviewedOn": Timestamp.fromDate(today),
      }).then((value) {
        if (isNotYear) {
          db.collection("years").add({"year": year});
        }
      });
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }

  Future<bool> change({
    required List adults,
    required List youth,
    required List children,
    required int newcomers,
    required List offerings,
    required List sermon,
    required String remarks,
    required String month,
    required String year,
    required int attendants,
    required String service,
    required Timestamp datetime,
    required bool review,
    required String regionID,
    required String divisionID,
    required String groupID,
    required String localID,
    required String doc,
  }) async {
    try {
      await db.collection("services").doc(doc).set({
        "adults": adults,
        "youth": youth,
        "children": children,
        "newcomers": newcomers,
        "offerings": offerings,
        "sermon": sermon,
        "remarks": remarks,
        "regionID": regionID,
        "divisionID": divisionID,
        "groupID": groupID,
        "localID": localID,
        "month": month,
        "year": year,
        "attendants": attendants,
        "review": review,
        "datetime": datetime,
        "service": service,
        "addedBy": "",
        "reviewedBy": "",
        "reviewedOn": datetime,
      });
      return true;
    } on FirebaseException catch (e) {
      Get.snackbar(
        e.code,
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      );
      return false;
    }
  }

  Future<ProcessInfo> edited(
    List? adults,
    List? youth,
    List? children,
    int newcomers,
    List? offerings,
    List? sermon,
    String? remarks,
    CurrentUser user,
    int attendants,
    String service,
    String doc,
  ) async {
    try {
      await db.collection("services").doc(doc).update({
        "adults": adults,
        "youth": youth,
        "children": children,
        "newcomers": newcomers,
        "offerings": offerings,
        "sermon": sermon,
        "remarks": remarks,
        "attendants": attendants,
        "review": true,
        "service": service,
        "reviewedBy": user.username,
        "reviewedOn": FieldValue.serverTimestamp(),
      });
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }

  Stream<List<ServiceModel>> get services =>
      db.collection("services").snapshots().map((QuerySnapshot querySnapshot) =>
          querySnapshot.docs.map((doc) => ServiceModel.fromDoc(doc)).toList());

  Stream<List<Users>> get users => db
      .collection("users")
      .where("uid", isEqualTo: uid)
      .snapshots()
      .map((QuerySnapshot snapshot) =>
          snapshot.docs.map((doc) => Users.fromDoc(doc)).toList());

  Stream<List<RegionModel>> get regions =>
      db.collection("regions").snapshots().map((QuerySnapshot snapshot) =>
          snapshot.docs.map((doc) => RegionModel.fromDoc(doc)).toList());

  Stream<List<DivisionModel>> get divisions =>
      db.collection("divisions").snapshots().map((QuerySnapshot snapshot) =>
          snapshot.docs.map((doc) => DivisionModel.fromDoc(doc)).toList());

  Stream<List<GroupModel>> get groups =>
      db.collection("groups").snapshots().map((QuerySnapshot snapshot) =>
          snapshot.docs.map((doc) => GroupModel.fromDoc(doc)).toList());

  Stream<List<LocalModel>> get locals =>
      db.collection("locals").snapshots().map((QuerySnapshot snapshot) =>
          snapshot.docs.map((doc) => LocalModel.fromDoc(doc)).toList());

  Future<Admin> get admin =>
      db.collection("admins").doc(uid).get().then((doc) => Admin.fromDoc(doc));

  Stream<List<Years>> get years =>
      db.collection("years").snapshots().map((QuerySnapshot snapshot) =>
          snapshot.docs.map((doc) => Years.fromDoc(doc)).toList());

  Future<ProcessInfo> update(
      String collection, String? documentID, CurrentUser user) async {
    try {
      await db.collection(collection).doc(documentID).update({
        "review": true,
        "reviewedBy": user.username,
        "reviewedOn": FieldValue.serverTimestamp(),
      });
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }

  Future<ProcessInfo> delete(String col, String? docID) async {
    try {
      await db.collection(col).doc(docID).delete();
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }

  Future<ProcessInfo> addPast(
    List? adults,
    List? campus,
    List? youth,
    List? children,
    int newcomers,
    List? offerings,
    List? sermon,
    String? remarks,
    String regionID,
    String divisionID,
    String groupID,
    String? localID,
    String? month,
    String? year,
    int attendants,
    Timestamp datetime,
    String service,
  ) async {
    try {
      await db.collection(service).add({
        "adults": adults,
        "youth": youth,
        "children": children,
        "newcomers": newcomers,
        "offerings": offerings,
        "sermon": sermon,
        "remarks": remarks,
        "regionID": regionID,
        "divisionID": divisionID,
        "groupID": groupID,
        "localID": localID,
        "month": month,
        "year": year,
        "attendants": attendants,
        "review": true,
        "datetime": datetime,
      });
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      return ProcessInfo(status: "failed", error: e);
    }
  }
}
