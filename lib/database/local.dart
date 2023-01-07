import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/cloud.dart';
import '../models/local.dart';

class Local with ChangeNotifier {
  final Box<IsUser> userBox;
  final Box<CurrentUser> cUserBox;

  Local({
    required this.userBox,
    required this.cUserBox,
  });

  IsUser? getUser(String key) {
    return userBox.get(key);
  }

  putUser(String key, IsUser model) {
    userBox.put(key, model);
    notifyListeners();
  }

  CurrentUser? user(String key) {
    return cUserBox.get(key);
  }

  void updateUser({required Admin admin, required String email}) {
    cUserBox.put(
      "user",
      CurrentUser(
        uid: admin.uid,
        email: email,
        username: admin.username,
        profile: admin.profile,
        position: admin.position,
        areaID: admin.areaID,
        area: admin.area,
        others: admin.others,
      ),
    );

    notifyListeners();
  }
}
