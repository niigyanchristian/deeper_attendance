import 'package:cloud_firestore/cloud_firestore.dart';

class CloudUser {
  final String? uid;
  final String? email;

  CloudUser({
    this.uid,
    this.email,
  });
}

class Users {
  final String? documentID;
  final String? username;
  final String? uid;
  final List? profile;

  Users({this.documentID, this.username, this.uid, this.profile});

  factory Users.fromDoc(dynamic doc) => Users(
        documentID: doc.id,
        username: doc["username"],
        uid: doc["uid"],
        profile: doc["profile"],
      );
}

class Admin {
  final String? docID;
  final String? username;
  final String? uid;
  final String? profile;
  final String? position;
  final String? areaID;
  final String? area;
  final List? others;

  Admin(
      {this.docID,
      this.username,
      this.uid,
      this.profile,
      this.position,
      this.areaID,
      this.area,
      this.others});

  factory Admin.fromDoc(dynamic doc) => Admin(
        /*documentID: doc.id,*/
        username: doc["username"],
        uid: doc["uid"],
        profile: doc["profile"],
        position: doc["position"],
        areaID: doc["areaID"],
        area: doc["area"],
        others: doc["others"],
      );
}

class Years {
  final String? docID;
  final String? year;

  Years({
    this.docID,
    this.year,
  });

  factory Years.fromDoc(dynamic doc) => Years(
        docID: doc.id,
        year: doc["year"],
      );
}

class RegionModel {
  final String? documentID;
  final String? regionID;
  final String? name;
  final String? creator;

  RegionModel({this.documentID, this.regionID, this.name, this.creator});

  factory RegionModel.fromDoc(dynamic doc) => RegionModel(
        documentID: doc.id,
        regionID: doc["regionID"],
        name: doc["name"],
        creator: doc["creator"],
      );
}

class DivisionModel {
  final String? documentID;
  final String? divisionID;
  final String? regionID;
  final String? name;
  final String? creator;
  final String? region;

  DivisionModel({
    this.documentID,
    this.divisionID,
    this.regionID,
    this.name,
    this.creator,
    this.region,
  });

  factory DivisionModel.fromDoc(dynamic doc) => DivisionModel(
        documentID: doc.id,
        divisionID: doc["divisionID"],
        regionID: doc["regionID"],
        name: doc["name"],
        creator: doc["creator"],
        region: doc["region"],
      );
}

class GroupModel {
  final String? documentID;
  final String? groupID;
  final String? divisionID;
  final String? regionID;
  final String? name;
  final String? creator;
  final String? region;
  final String? division;

  GroupModel({
    this.documentID,
    this.groupID,
    this.divisionID,
    this.regionID,
    this.name,
    this.creator,
    this.region,
    this.division,
  });

  factory GroupModel.fromDoc(dynamic doc) => GroupModel(
        documentID: doc.id,
        groupID: doc["groupID"],
        divisionID: doc["divisionID"],
        regionID: doc["regionID"],
        name: doc["name"],
        creator: doc["creator"],
        region: doc["region"],
        division: doc["division"],
      );
}

class LocalModel {
  final String? documentID;
  final String? localID;
  final String? groupID;
  final String? divisionID;
  final String? regionID;
  final String? name;
  final String? creator;
  final String? region;
  final String? division;
  final String? group;

  LocalModel({
    this.documentID,
    this.localID,
    this.groupID,
    this.divisionID,
    this.regionID,
    this.name,
    this.creator,
    this.region,
    this.division,
    this.group,
  });

  factory LocalModel.fromDoc(dynamic doc) => LocalModel(
        documentID: doc.id,
        localID: doc["localID"],
        groupID: doc["groupID"],
        divisionID: doc["divisionID"],
        regionID: doc["regionID"],
        name: doc["name"],
        creator: doc["creator"],
        region: doc["region"],
        division: doc["division"],
        group: doc["group"],
      );
}

class ServiceModel {
  final String? docID;
  final List? adults;

  final List? youth;
  final List? children;
  final int? newcomers;
  final List? offerings;
  final List? sermon;
  final String? remarks;
  final String? regionID;
  final String? divisionID;
  final String? groupID;
  final String? localID;
  final String? month;
  final String? year;
  final int? attendants;
  final bool? review;
  final Timestamp? datetime;
  final Timestamp? reviewedOn;
  final String? reviewedBy;
  final String? addedBy;
  final String? service;

  ServiceModel({
    this.docID,
    this.adults,
    this.youth,
    this.children,
    this.newcomers,
    this.offerings,
    this.sermon,
    this.remarks,
    this.regionID,
    this.divisionID,
    this.groupID,
    this.localID,
    this.month,
    this.year,
    this.attendants,
    this.review,
    this.datetime,
    this.reviewedOn,
    this.reviewedBy,
    this.addedBy,
    this.service,
  });

  factory ServiceModel.fromDoc(dynamic doc) => ServiceModel(
        docID: doc.id,
        adults: doc["adults"],
        youth: doc["youth"],
        children: doc["children"],
        newcomers: doc["newcomers"],
        offerings: doc["offerings"],
        sermon: doc["sermon"],
        remarks: doc["remarks"],
        regionID: doc["regionID"],
        divisionID: doc["divisionID"],
        groupID: doc["groupID"],
        localID: doc["localID"],
        month: doc["month"],
        year: doc["year"],
        attendants: doc["attendants"],
        review: doc["review"],
        datetime: doc["datetime"],
        reviewedOn: doc["reviewedOn"],
        reviewedBy: doc["reviewedBy"],
        addedBy: doc["addedBy"],
        service: doc["service"],
      );
}

class SundayModel {
  final String? docID;
  final List? adults;
  final List? youth;
  final List? children;
  final int? newcomers;
  final List? offerings;
  final List? sermon;
  final String? remarks;
  final String? regionID;
  final String? divisionID;
  final String? groupID;
  final String? localID;
  final String? month;
  final String? year;
  final int? attendants;
  final bool? review;
  final Timestamp? datetime;

  SundayModel(
      {this.docID,
      this.adults,
      this.youth,
      this.children,
      this.newcomers,
      this.offerings,
      this.sermon,
      this.remarks,
      this.regionID,
      this.divisionID,
      this.groupID,
      this.localID,
      this.month,
      this.year,
      this.attendants,
      this.review,
      this.datetime});

  factory SundayModel.fromDoc(dynamic doc) => SundayModel(
        docID: doc.id,
        adults: doc["adults"],
        youth: doc["youth"],
        children: doc["children"],
        newcomers: doc["newcomers"],
        offerings: doc["offerings"],
        sermon: doc["sermon"],
        remarks: doc["remarks"],
        regionID: doc["regionID"],
        divisionID: doc["divisionID"],
        groupID: doc["groupID"],
        localID: doc["localID"],
        month: doc["month"],
        year: doc["year"],
        attendants: doc["attendants"],
        review: doc["review"],
        datetime: doc["datetime"],
      );
}

class BibleModel {
  final String? docID;
  final List? adults;

  final List? youth;
  final List? children;
  final int? newcomers;
  final List? offerings;
  final List? sermon;
  final String? remarks;
  final String? regionID;
  final String? divisionID;
  final String? groupID;
  final String? localID;
  final String? month;
  final String? year;
  final int? attendants;
  final bool? review;
  final Timestamp? datetime;

  BibleModel({
    this.docID,
    this.adults,
    this.youth,
    this.children,
    this.newcomers,
    this.offerings,
    this.sermon,
    this.remarks,
    this.regionID,
    this.divisionID,
    this.groupID,
    this.localID,
    this.month,
    this.year,
    this.attendants,
    this.review,
    this.datetime,
  });

  factory BibleModel.fromDoc(dynamic doc) => BibleModel(
        docID: doc.id,
        adults: doc["adults"],
        youth: doc["youth"],
        children: doc["children"],
        newcomers: doc["newcomers"],
        offerings: doc["offerings"],
        sermon: doc["sermon"],
        remarks: doc["remarks"],
        regionID: doc["regionID"],
        divisionID: doc["divisionID"],
        groupID: doc["groupID"],
        localID: doc["localID"],
        month: doc["month"],
        year: doc["year"],
        attendants: doc["attendants"],
        review: doc["review"],
        datetime: doc["datetime"],
      );
}

class RevivalModel {
  final String? docID;
  final List? adults;

  final List? youth;
  final List? children;
  final int? newcomers;
  final List? offerings;
  final List? sermon;
  final String? remarks;
  final String? regionID;
  final String? divisionID;
  final String? groupID;
  final String? localID;
  final String? month;
  final String? year;
  final int? attendants;
  final bool? review;
  final Timestamp? datetime;

  RevivalModel({
    this.docID,
    this.adults,
    this.youth,
    this.children,
    this.newcomers,
    this.offerings,
    this.sermon,
    this.remarks,
    this.regionID,
    this.divisionID,
    this.groupID,
    this.localID,
    this.month,
    this.year,
    this.attendants,
    this.review,
    this.datetime,
  });

  factory RevivalModel.fromDoc(dynamic doc) => RevivalModel(
        docID: doc.id,
        adults: doc["adults"],
        youth: doc["youth"],
        children: doc["children"],
        newcomers: doc["newcomers"],
        offerings: doc["offerings"],
        sermon: doc["sermon"],
        remarks: doc["remarks"],
        regionID: doc["regionID"],
        divisionID: doc["divisionID"],
        groupID: doc["groupID"],
        localID: doc["localID"],
        month: doc["month"],
        year: doc["year"],
        attendants: doc["attendants"],
        review: doc["review"],
        datetime: doc["datetime"],
      );
}

class OthersModel {
  final String? docID;
  final List? adults;

  final List? youth;
  final List? children;
  final int? newcomers;
  final List? offerings;
  final List? sermon;
  final String? remarks;
  final String? regionID;
  final String? divisionID;
  final String? groupID;
  final String? localID;
  final String? month;
  final String? year;
  final int? attendants;
  final bool? review;
  final Timestamp? datetime;

  OthersModel({
    this.docID,
    this.adults,
    this.youth,
    this.children,
    this.newcomers,
    this.offerings,
    this.sermon,
    this.remarks,
    this.regionID,
    this.divisionID,
    this.groupID,
    this.localID,
    this.month,
    this.year,
    this.attendants,
    this.review,
    this.datetime,
  });

  factory OthersModel.fromDoc(dynamic doc) => OthersModel(
        docID: doc.id,
        adults: doc["adults"],
        youth: doc["youth"],
        children: doc["children"],
        newcomers: doc["newcomers"],
        offerings: doc["offerings"],
        sermon: doc["sermon"],
        remarks: doc["remarks"],
        regionID: doc["regionID"],
        divisionID: doc["divisionID"],
        groupID: doc["groupID"],
        localID: doc["localID"],
        month: doc["month"],
        year: doc["year"],
        attendants: doc["attendants"],
        review: doc["review"],
        datetime: doc["datetime"],
      );
}
