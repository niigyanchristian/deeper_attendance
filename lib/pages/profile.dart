import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../components/alert.dart';
import '../components/backdrop.dart';
import '../controllers/auth.dart';
import '../controllers/blocs.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../functions/app.dart';
import '../models/cloud.dart';
import '../models/local.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class Profile extends StatefulWidget with PageState {
  final List<RegionModel>? regions;
  final List<DivisionModel>? divisions;
  final List<GroupModel>? groups;
  final List<LocalModel>? locals;
  final List<Admin>? admin;

  const Profile(
      {Key? key,
      this.regions,
      this.divisions,
      this.groups,
      this.locals,
      this.admin})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AuthCtx authCtx = Get.find<AuthCtx>();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  bool biometric = false;
  bool change = false;
  bool loading = false;
  bool saved = false;
  bool changeTheme = false;
  final LocalAuthentication auth = LocalAuthentication();
  TextEditingController passwordChange = TextEditingController();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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

  playAnimation() {
    _controller.reverse();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List profile = ["National", "Regional", "Division", "Group", "Location"];
  int selected = 0;

  bool error = false;
  String? errorMessage = "";

  _errorTimer() {
    Timer(const Duration(milliseconds: 3000), () {
      error
          ? setState(() {
              error = false;
            })
          : setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    TextStyling textStyling = themes.textStyling;
    Local local = Provider.of<Local>(context);
    CurrentUser user = local.user("user")!;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Stack(
        children: [
          SizedBox(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 45),
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Spacer(),
                            Text(user.username!, style: textStyling.bold16),
                            user.profile == "national" || user.profile == ""
                                ? const SizedBox.shrink()
                                : Container(
                                    decoration: themes.foreground,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          user.profile!,
                                          style: textStyling.bold12,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Spacer(),
                            Container(
                              decoration: themes.foreground,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Row(
                                children: [
                                  Text(
                                    user.profile == "national" ||
                                            user.profile == ""
                                        ? "National"
                                        : user.area!,
                                    style: textStyling.bold12,
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: theme.primary,
                                    size: 20,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        change = true;
                      });
                    },
                    child: Container(
                      width: 320,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 25),
                      decoration: themes.foreground,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 15),
                              child: Text(
                                "Change Password",
                                style: textStyling.bold16,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 15),
                                child: Text(
                                  "Tab to change password",
                                  style: textStyling.regularMuted14,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -30,
                              top: -10,
                              child: Icon(
                                Icons.lock_outline,
                                size: 100,
                                color: theme.primary!.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        changeTheme = true;
                      });
                    },
                    child: Container(
                      width: 320,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 25),
                      decoration: themes.foreground,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: themes.isDark
                                            ? FaIcon(
                                                FontAwesomeIcons.cloudMoon,
                                                size: 28,
                                                color: theme.primary,
                                              )
                                            : FaIcon(
                                                FontAwesomeIcons.cloudSun,
                                                size: 28,
                                                color: theme.primary,
                                              ),
                                      ),
                                      const SizedBox(width: 15),
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        child: themes.isDark
                                            ? Text(
                                                "Dark Mode",
                                                style: textStyling.medium16,
                                                textAlign: TextAlign.start,
                                                key: UniqueKey(),
                                              )
                                            : Text(
                                                "Light Mode",
                                                style: textStyling.medium16,
                                                overflow: TextOverflow.ellipsis,
                                                key: UniqueKey(),
                                              ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        themes.themeMode == ThemeMode.system
                                            ? "System Theme"
                                            : "Theme",
                                        style: textStyling.regular14!
                                            .copyWith(color: muted),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: -30,
                              top: -10,
                              child: Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 100,
                                color: theme.primary!.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        biometric = true;
                      });
                    },
                    child: Container(
                      width: 320,
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 25),
                      decoration: themes.foreground,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 15),
                              child: Text(
                                local.getUser("biometric")!.biometric!
                                    ? "Activated"
                                    : "Deactivated",
                                style: textStyling.bold16,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10.0, left: 15),
                                child: Text(
                                  "Biometric Authentication",
                                  style: textStyling.regularMuted14,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -40,
                              top: -20,
                              child: Icon(
                                Icons.fingerprint_outlined,
                                size: 120,
                                color: theme.primary!.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          biometric
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      biometric = false;
                    });
                  },
                  child: const BackDrop(),
                )
              : Container(),
          change
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      change = false;
                    });
                  },
                  child: const BackDrop(),
                )
              : Container(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            bottom: biometric ? 0 : -400,
            curve: Curves.elasticOut,
            child: SizedBox(
              height: height,
              width: width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width < 370 ? width - 20 : width - 40,
                  height: 220,
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  margin: EdgeInsets.only(bottom: width < 370 ? 10 : 20),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.15),
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 7),
                            child: Row(
                              children: [
                                Text(
                                  "Biometric Authentication",
                                  style: textStyling.bold16,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: theme.primary,
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: [
                                          theme.secondary!,
                                          theme.primary!
                                        ],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: const Icon(
                                      Icons.fingerprint,
                                      size: 55,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: [
                                          theme.secondary!,
                                          theme.primary!
                                        ],
                                      ).createShader(bounds);
                                    },
                                    blendMode: BlendMode.srcATop,
                                    child: const FaIcon(
                                      FontAwesomeIcons.userCircle,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Fingerprint or Facial Recognition",
                                style: textStyling.medium14,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  biometric = false;
                                });
                              },
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: muted,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (local.getUser("biometric")!.biometric!) {
                                  local.putUser(
                                      "biometric", IsUser(biometric: false));
                                  setState(() {
                                    biometric = false;
                                  });
                                } else {
                                  authenticate(local);
                                }
                              },
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: theme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      local.getUser("biometric")!.biometric!
                                          ? "Deactivate"
                                          : "Activate",
                                      style: textStyling.medium17,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            bottom: change ? 0 : -400,
            curve: Curves.elasticOut,
            child: SizedBox(
              height: height,
              width: width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width < 370 ? width - 20 : width - 40,
                  height: 200,
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  margin: EdgeInsets.only(bottom: width < 370 ? 10 : 20),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.15),
                        offset: const Offset(0.0, 1.0),
                        blurRadius: 15,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 7),
                            child: Row(
                              children: [
                                Text(
                                  "Password Change",
                                  style: textStyling.bold16,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: theme.primary,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: 300,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.sentences,
                              onFieldSubmitted: (value) {
                                if (value != "") {
                                  _changeProcess(value, local);
                                } else {
                                  setState(() {
                                    error = true;
                                    errorMessage =
                                        "Enter new password to proceed";
                                  });
                                  _errorTimer();
                                }
                              },
                              keyboardType: TextInputType.text,
                              controller: passwordChange,
                              style: textStyling.medium16,
                              cursorColor: theme.secondary,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter new password',
                                hintStyle: textStyling.bold18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  change = false;
                                  loading = false;
                                  saved = false;
                                });
                              },
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    color: muted,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (passwordChange.text != "") {
                                  FocusScope.of(context).unfocus();
                                  _changeProcess(passwordChange.text, local);
                                } else {
                                  setState(() {
                                    error = true;
                                    errorMessage =
                                        "Enter new password to proceed";
                                  });
                                  _errorTimer();
                                }
                              },
                              child: SizedBox(
                                width: 150,
                                height: 45,
                                child: Center(
                                  child: loading
                                      ? saved
                                          ? Icon(
                                              Icons.check,
                                              color: theme.primary,
                                            )
                                          : SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                backgroundColor: theme.primary,
                                              ),
                                            )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: theme.primary,
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "Change",
                                              style: textStyling.medium17,
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          changeTheme
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      changeTheme = false;
                    });
                  },
                  child: const BackDrop(),
                )
              : Container(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1200),
            bottom: changeTheme ? 0 : -400,
            curve: Curves.elasticOut,
            child: SizedBox(
              height: height,
              width: width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 340,
                  height: 205,
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  margin: EdgeInsets.only(bottom: width < 370 ? 10 : 20),
                  decoration: themes.pops,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 7),
                        child: Row(
                          children: [
                            Text(
                              "Theme",
                              style: textStyling.bold16!,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: muted,
                      ),
                      InkWell(
                        onTap: () {
                          themes.changeTheme("light");
                          setState(() {
                            changeTheme = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.cloudSun,
                                size: 26,
                                color: muted,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Light Mode",
                                style: textStyling.medium16,
                              ),
                              const Spacer(),
                              themes.themeMode == ThemeMode.light
                                  ? Icon(
                                      Icons.check,
                                      color: themes.appTheme.primary,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          themes.changeTheme("dark");
                          setState(() {
                            changeTheme = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.cloudMoon,
                                size: 26,
                                color: muted,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Dark Mode",
                                style: textStyling.medium16,
                              ),
                              const Spacer(),
                              themes.themeMode == ThemeMode.dark
                                  ? Icon(
                                      Icons.check,
                                      color: themes.appTheme.primary,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          themes.changeTheme("system");
                          setState(() {
                            changeTheme = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            children: [
                              Icon(
                                Icons.android_rounded,
                                size: 28,
                                color: muted,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "System Theme",
                                style: textStyling.medium16,
                              ),
                              const Spacer(),
                              themes.themeMode == ThemeMode.system
                                  ? Icon(
                                      Icons.check,
                                      color: themes.appTheme.primary,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Errors(
            error: error,
            errorMessage: errorMessage,
          ),
        ],
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
              biometricOnly: true);
          if (authenticated) {
            biometricMethod.putUser("biometric", IsUser(biometric: true));
            setState(() {
              biometric = false;
            });
          }
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          final authenticated = await auth.authenticate(
              localizedReason:
                  'Use your biometric signatures to authenticate. ${fxn.biometrics(availableBiometrics)}',
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true);
          if (authenticated) {
            biometricMethod.putUser("biometric", IsUser(biometric: true));
            setState(() {
              biometric = false;
            });
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

  void _changeProcess(String value, Local local) {
    setState(() {
      loading = true;
    });
    authCtx.changePassword(value).then((value) {
      if (value.status == "success") {
        Get.snackbar(
          "Successful",
          "Password change was successful",
          snackPosition: SnackPosition.BOTTOM,
        );
        setState(() {
          passwordChange.text = "";
          saved = true;
        });
        Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            change = false;
            loading = false;
          });
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    });
  }
}
