import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../components/alert.dart';
import '../controllers/auth.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../functions/app.dart';
import '../models/cloud.dart';
import '../models/local.dart';
import '../services/cloud.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  AuthCtx authCtx = Get.find<AuthCtx>();
  final LocalAuthentication auth = LocalAuthentication();
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  bool success = false;
  String? errorMessage = "";
  String successMessage = "";
  bool error = false;
  bool saved = false;
  bool passwordObscure = true;
  bool showObscure = false;
  FocusNode? passwordFocus;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: const Offset(0.0, 0.0))
            .animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    playAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  playAnimation() {
    _controller.reverse();
    _controller.forward();
  }

  _errorTimer() {
    Timer(const Duration(milliseconds: 4000), () {
      error
          ? setState(() {
              error = false;
            })
          : setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    TextStyling textStyling = themes.textStyling;
    Local local = Provider.of<Local>(context);

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SizedBox(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Positioned(
                    bottom: -100,
                    left: -45,
                    width: width * 1.25,
                    child: const Opacity(
                      opacity: 0.4,
                      child: Image(
                        image: AssetImage("assets/images/deeper.png"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 45),
                        const Image(
                          image: AssetImage("assets/images/deeper.png"),
                          width: 100,
                        ),
                        Text(
                          "Deeper Life\nBible Church",
                          style: textStyling.bold22,
                        ),
                        const SizedBox(height: 25),
                        local.getUser("biometric")!.biometric!
                            ? Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      authenticate(local);
                                    },
                                    child: Icon(
                                      Icons.fingerprint_outlined,
                                      color: theme.primary,
                                      size: 50,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25),
                                    child: Text(
                                      "or",
                                      style: textStyling.medium16,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        Column(
                          children: [
                            Container(
                              width: 320,
                              height: 85,
                              padding: const EdgeInsets.only(
                                right: 15,
                                left: 15,
                                top: 10,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 15,
                              ),
                              decoration: BoxDecoration(
                                color: theme.card,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withOpacity(0.2),
                                    offset: const Offset(0.0, 10.0),
                                    blurRadius: 15,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Email",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.alternate_email_rounded,
                                        color: theme.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 290,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (value) {
                                        if (value != "") {
                                        } else {
                                          if (!error) {
                                            _errorTimer();
                                            setState(() {
                                              errorMessage =
                                                  "Email field can't be empty";
                                              error = true;
                                            });
                                          }
                                        }
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      controller: email,
                                      style: textStyling.mediumMuted18,
                                      onChanged: (value) {
                                        if (error) {
                                          setState(() {
                                            error = false;
                                          });
                                        }
                                      },
                                      cursorColor: theme.primary,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email address',
                                        hintStyle: textStyling.mediumMuted18,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              width: 320,
                              height: 85,
                              padding: const EdgeInsets.only(
                                right: 15,
                                left: 15,
                                top: 10,
                              ),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: theme.card,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: black.withOpacity(0.2),
                                    offset: const Offset(0.0, 10.0),
                                    blurRadius: 15,
                                    spreadRadius: -5,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Password",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                      showObscure
                                          ? passwordObscure
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      passwordObscure = false;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.visibility_outlined,
                                                    color: theme.primary,
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      passwordObscure = true;
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .visibility_off_outlined,
                                                    color: theme.primary,
                                                  ),
                                                )
                                          : Icon(
                                              Icons.lock_open,
                                              color: theme.primary,
                                            ),
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 290,
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (value) {
                                        if (value != "") {
                                          process(local, authCtx);
                                        } else {
                                          if (!error) {
                                            _errorTimer();
                                            setState(() {
                                              errorMessage =
                                                  "Password field can't be empty";
                                              error = true;
                                            });
                                          }
                                        }
                                      },
                                      keyboardType: TextInputType.text,
                                      controller: password,
                                      style: textStyling.mediumMuted18,
                                      obscureText: passwordObscure,
                                      onChanged: (value) {
                                        if (error) {
                                          setState(() {
                                            error = false;
                                          });
                                        }
                                        setState(() {
                                          showObscure = true;
                                        });
                                      },
                                      cursorColor: theme.primary,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Choose password',
                                        hintStyle: textStyling.mediumMuted18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            if (password.text != "") {
                              FocusScope.of(context).unfocus();
                              process(local, authCtx);
                            } else {
                              if (!error) {
                                _errorTimer();
                                setState(() {
                                  errorMessage =
                                      "Password field can't be empty";
                                  error = true;
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 320,
                            height: 45,
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(22.5),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.6),
                                  offset: const Offset(0.0, 10.0),
                                  blurRadius: 15,
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: loading
                                  ? saved
                                      ? Icon(
                                          Icons.check,
                                          color: white,
                                        )
                                      : SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                            backgroundColor: white,
                                          ),
                                        )
                                  : Text(
                                      "Login",
                                      style: textStyling.boldWhite16,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Errors(
                    error: error,
                    errorMessage: errorMessage,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void authenticate(Local biometricMethod) async {
    final canCheck = await auth.canCheckBiometrics;

    if (canCheck) {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (Platform.isAndroid) {
        if (availableBiometrics.contains(BiometricType.face)) {
          final authenticated = await auth.authenticate(
            localizedReason:
                'Use your biometric signatures to authenticate. ${fxn.biometrics(availableBiometrics)}',
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          );
          if (authenticated) {
            biometricMethod.putUser(
              "available",
              IsUser(available: true),
            );
          }
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          final authenticated = await auth.authenticate(
              localizedReason:
                  'Use your biometric signatures to authenticate. ${fxn.biometrics(availableBiometrics)}',
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true);
          if (authenticated) {
            biometricMethod.putUser(
              "available",
              IsUser(available: true),
            );
          }
        }
      }
    } else {
      setState(() {
        error = true;
        errorMessage =
            "Sorry it seems your phone does not support biometric authentication";
      });
      _errorTimer();
    }
  }

  process(Local local, AuthCtx authCtx) {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    authCtx
        .signInWithEmailAndPassword(
      email.text,
      password.text,
      local,
    )
        .then((value) {
      if (value.status == "success") {
        Cloud()
            .db
            .collection('admins')
            .doc(value.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            final data = documentSnapshot.data();
            local.updateUser(admin: Admin.fromDoc(data), email: email.text);
            local.putUser(
              "available",
              IsUser(available: true),
            );
            setState(() {
              email.text = "";
              password.text = "";
              saved = true;
            });
          }
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }
}
