import 'dart:async';

import 'package:deeper/components/alert.dart';
import 'package:deeper/controllers/theme.dart';
import 'package:deeper/models/cloud.dart';
import 'package:deeper/styles/colours.dart';
import 'package:deeper/styles/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NationalUser extends StatefulWidget {
  final List<Admin>? admin;

  const NationalUser({Key? key, this.admin}) : super(key: key);

  @override
  _NationalUserState createState() => _NationalUserState();
}

class _NationalUserState extends State<NationalUser>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool error = false;
  String? errorMessage = "";
  bool loading = false;
  bool saved = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController position = TextEditingController();

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.05), end: Offset(0.0, 0.0)).animate(
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
    Timer(Duration(milliseconds: 4000), () {
      error
          ? setState(() {
              error = false;
            })
          : setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    bool isDark = themes.theme!;
    TextStyling textStyling = themes.textStyling;

    return Scaffold(
      backgroundColor: isDark ? black : theme.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Stack(
            children: [
              Container(
                height: screenHeight,
                width: screenWidth,
                color: isDark ? white.withOpacity(0.1) : transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 45),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.only(right: 20, left: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondary,
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.2),
                                  offset: Offset(0.0, 10.0),
                                  blurRadius: 15,
                                  spreadRadius: -5,
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: white,
                                size: 22,
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      SizedBox(height: 25),
                      Text(
                        "National User",
                        style: textStyling.bold25,
                      ),
                      SizedBox(height: 35),
                      Container(
                        width: 320,
                        height: 85,
                        padding: EdgeInsets.only(
                          right: 15,
                          left: 15,
                          bottom: 15,
                        ),
                        margin: EdgeInsets.only(
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.2),
                              offset: Offset(0.0, 10.0),
                              blurRadius: 15,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      if (value != "") {
                                      } else {
                                        if (!error) {
                                          _errorTimer();
                                          setState(() {
                                            errorMessage =
                                            "Name field can't be empty";
                                            error = true;
                                          });
                                        }
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: name,
                                    style: textStyling.medium18,
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
                                      hintText: 'Name',
                                      hintStyle: textStyling.bold18,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.perm_identity,
                                  color: theme.primary,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Name",
                                style: textStyling.regularMuted14,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 320,
                        height: 85,
                        padding: EdgeInsets.only(
                          right: 15,
                          left: 15,
                          bottom: 15,
                        ),
                        margin: EdgeInsets.only(
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.2),
                              offset: Offset(0.0, 10.0),
                              blurRadius: 15,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      if (value != "") {
                                      } else {
                                        if (!error) {
                                          _errorTimer();
                                          setState(() {
                                            errorMessage =
                                            "Position field can't be empty";
                                            error = true;
                                          });
                                        }
                                      }
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: position,
                                    style: textStyling.medium18,
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
                                      hintText: 'Position',
                                      hintStyle: textStyling.bold18,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.perm_identity,
                                  color: theme.primary,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Position",
                                style: textStyling.regularMuted14,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 320,
                        height: 85,
                        padding: EdgeInsets.only(
                          right: 15,
                          left: 15,
                          bottom: 15,
                        ),
                        margin: EdgeInsets.only(
                          bottom: 15,
                        ),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.2),
                              offset: Offset(0.0, 10.0),
                              blurRadius: 15,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 240,
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
                                    style: textStyling.medium18,
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
                                      hintStyle: textStyling.bold18,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.alternate_email_rounded,
                                  color: theme.primary,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Email",
                                style: textStyling.regularMuted14,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 320,
                        height: 85,
                        padding: EdgeInsets.only(
                          right: 15,
                          left: 15,
                          bottom: 15,
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: black.withOpacity(0.2),
                              offset: Offset(0.0, 10.0),
                              blurRadius: 15,
                              spreadRadius: -5,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 240,
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {
                                      if (value != "") {
                                        process(name.text, position.text, email.text, value);
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
                                    style: textStyling.medium18,
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
                                      hintText: 'Choose password',
                                      hintStyle: textStyling.bold18,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.lock_open,
                                  color: theme.primary,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Password",
                                style: textStyling.regularMuted14,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          if (password.text != "" && email.text != "" && name.text != "" && position.text != "") {
                            FocusScope.of(context).unfocus();
                            process(name.text, position.text, email.text, password.text);
                          } else {
                            if (!error) {
                              _errorTimer();
                              setState(() {
                                errorMessage = "Make sure a fields are filled";
                                error = true;
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 220,
                          height: 45,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(22.5),
                            boxShadow: [
                              BoxShadow(
                                color: black.withOpacity(0.6),
                                offset: Offset(0.0, 10.0),
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
                                : Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                backgroundColor: white,
                              ),
                            )
                                : Text(
                              "Add User",
                              style: textStyling.boldWhite16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    );
  }

  process(String nameValue, String positionValue, String emailValue, String passwordValue) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
   /* await AuthService().registerAdmins(
        nameValue,
        emailValue,
        passwordValue,
        "national",
        positionValue,
        "",
        "", []).then((value) {
      if (value.status == "success") {
        setState(() {
          saved = true;
        });
        Timer(Duration(milliseconds: 1000), () {
          Navigator.pop(context);
        });
      } else {
        setState(() {
          loading = false;
          error = true;
          errorMessage = value.error!.message;
        });
        _errorTimer();
      }
    });*/
  }
}
