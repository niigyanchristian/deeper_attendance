import 'package:firebase_core/firebase_core.dart';

class ProcessInfo {
  final String? status;
  final String? uid;
  final FirebaseException? error;

  ProcessInfo({this.status, this.error, this.uid});
}

class SelectedSection {
  final String? area;
  final String? areaID;
  final String? type;
  final bool? isSection;

  SelectedSection({this.area, this.areaID, this.type, this.isSection});
}