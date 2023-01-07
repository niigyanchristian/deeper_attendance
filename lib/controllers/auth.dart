import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/blocs.dart';
import '../controllers/cloud.dart';
import '../database/local.dart';
import '../models/app.dart';
import '../models/local.dart';
import '../services/cloud.dart';

class AuthCtx extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();

  User get user => _user.value!;

  @override
  void onInit() {
    _user.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  void signInAnon(Local local) async {
    try {
      await _auth.signInAnonymously();
      local.putUser("started", IsUser(started: true));
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Error",
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      );
    }
  }

  Future<ProcessInfo> signInWithEmailAndPassword(
      String email, String password, Local local) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      local.putUser("user", IsUser(user: user.uid));
      Get.find<CloudCtx>().admin = await Cloud(uid: user.uid).admin;
      return ProcessInfo(status: "success", uid: user.uid);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Error",
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      );
      return ProcessInfo(status: "failed", error: e);
    }
  }

  void signOut(Local local, MenuBloc menuBloc, MenuState menuState,
      PageBloc pageBloc, AnimationController animationController) async {
    final animationStatus = animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
    menuState.add(Bool.deactivate);
    menuBloc.add(PageVal.dashboard);
    pageBloc.add(PageVal.dashboard);
    local.putUser(
      "available",
      IsUser(available: false),
    );
    Get.find<CloudCtx>().clear();
  }

  Future<ProcessInfo> changePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
      return ProcessInfo(status: "success");
    } on FirebaseException catch (e) {
      Get.snackbar(
        "Logout Error",
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      );
      return ProcessInfo(status: "failed", error: e);
    }
  }
}
