import 'dart:async';

import 'package:deeper/components/alert.dart';
import 'package:deeper/components/widgets.dart';
import 'package:deeper/controllers/theme.dart';
import 'package:deeper/models/cloud.dart';
import 'package:deeper/styles/colours.dart';
import 'package:deeper/styles/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupUser extends StatefulWidget {
  final List<Admin>? admin;

  const GroupUser({Key? key, this.admin}) : super(key: key);

  @override
  _GroupUserState createState() => _GroupUserState();
}

class _GroupUserState extends State<GroupUser>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  PageController? pageController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? selectedGroup = "";
  String? selectedGroupID = "";
  String? selectedDivisionID = "";
  String? selectedRegionID = "";
  bool addRegion = false;
  String user = "";
  String selectedEmail = "";
  String selectedPassword = "";
  String selectedPosition = "";
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
    pageController =
        PageController(viewportFraction: 0.6, keepPage: true, initialPage: 0);
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
    List<GroupModel> groupsModel = Provider.of<List<GroupModel>>(context);
    List<GroupModel> groups = groupsModel.where((element) => element.divisionID == widget.admin!.first.areaID).toList();

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
                      Column(
                        children: [
                          Text(
                            "Groups",
                            style: textStyling.bold25,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 65, vertical: 20),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: textStyling.regular16,
                                children: [
                                  TextSpan(
                                    text: "Available groups for this division",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35),
                      Container(
                        height: 275,
                        child: PageView(
                          pageSnapping: true,
                          physics: ClampingScrollPhysics(),
                          controller: pageController,
                          children: [
                            for (int i = 0; i < groups.length; i++)
                              group(
                                  groups[i].name,
                                  groups[i].documentID,
                                  groups[i].divisionID,
                                  groups[i].regionID,
                                  i,
                                  screenWidth,
                                  textStyling),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              addRegion
                  ? Container(
                      height: screenHeight,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.2),
                      ),
                    )
                  : Container(),
              AnimatedPositioned(
                duration: Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                left: 0,
                right: 0,
                top: addRegion ? 0 : (-screenHeight - 20),
                child: Container(
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: theme.card,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: 45),
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  addRegion = false;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.only(right: 20, left: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: theme.secondary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: black.withOpacity(0.7),
                                      offset: Offset(0.0, 5.0),
                                      blurRadius: 15,
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Name",
                                style: textStyling.bold16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 340,
                          decoration: BoxDecoration(
                            color: grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              if (value != "") {
                              } else {
                                setState(() {
                                  error = true;
                                  errorMessage =
                                      "Field cannot be empty on submit";
                                  _errorTimer();
                                });
                              }
                            },
                            onChanged: (value) {
                              user = value;
                            },
                            keyboardType: TextInputType.text,
                            style: textStyling.medium16,
                            cursorColor: theme.secondary,
                            controller: name,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'name',
                              hintStyle: textStyling.bold18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Position",
                                style: textStyling.bold16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 340,
                          decoration: BoxDecoration(
                            color: grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              if (value != "") {
                              } else {
                                setState(() {
                                  error = true;
                                  errorMessage =
                                      "Field cannot be empty on submit";
                                  _errorTimer();
                                });
                              }
                            },
                            onChanged: (value) {
                              selectedPosition = value;
                            },
                            keyboardType: TextInputType.text,
                            style: textStyling.medium16,
                            cursorColor: theme.secondary,
                            controller: position,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'position',
                              hintStyle: textStyling.bold18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Email",
                                style: textStyling.bold16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 340,
                          decoration: BoxDecoration(
                            color: grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              if (value != "") {
                              } else {
                                setState(() {
                                  error = true;
                                  errorMessage =
                                      "Field cannot be empty on submit";
                                  _errorTimer();
                                });
                              }
                            },
                            onChanged: (value) {
                              selectedEmail = value;
                            },
                            keyboardType: TextInputType.text,
                            style: textStyling.medium16,
                            cursorColor: theme.secondary,
                            controller: email,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'email',
                              hintStyle: textStyling.bold18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                            top: 20,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Password",
                                style: textStyling.bold16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 340,
                          decoration: BoxDecoration(
                            color: grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              if (value != "") {
                              } else {
                                setState(() {
                                  error = true;
                                  errorMessage =
                                      "Field cannot be empty on submit";
                                  _errorTimer();
                                });
                              }
                            },
                            onChanged: (value) {
                              selectedPassword = value;
                            },
                            keyboardType: TextInputType.text,
                            style: textStyling.medium16,
                            cursorColor: theme.secondary,
                            controller: password,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'password',
                              hintStyle: textStyling.bold18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (user != "" ||
                                selectedEmail != "" ||
                                selectedPassword != "") {
                              process(
                                  user,
                                  selectedEmail,
                                  selectedPassword,
                                  selectedGroup,
                                  selectedGroupID,
                                  selectedDivisionID,
                                  selectedRegionID,
                                  widget.admin!.first.username,
                                  selectedPosition);
                            } else {
                              setState(() {
                                error = true;
                                errorMessage =
                                    "Field cannot be empty on submit";
                                _errorTimer();
                              });
                            }
                          },
                          child: Container(
                            height: 45,
                            width: 290,
                            margin: EdgeInsets.only(top: 30, bottom: 30),
                            decoration: BoxDecoration(
                              color: theme.secondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(isDark ? 0.6 : 0.5),
                                  offset: Offset(0.0, 6.0),
                                  blurRadius: isDark ? 17 : 15,
                                  spreadRadius: isDark ? -5 : -10,
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
                                      "Insert",
                                      style: textStyling.boldWhite16,
                                    ),
                            ),
                          ),
                        ),
                      ],
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
        ),
      ),
    );
  }

  Widget group(
    String? group,
    String? groupID,
    String? divisionID,
    String? regionID,
    int current,
    double screenWidth,
    TextStyling textStyling,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          addRegion = true;
          selectedGroupID = groupID;
          selectedDivisionID = divisionID;
          selectedRegionID = regionID;
          selectedGroup = group;
        });
      },
      child: PageViewItems(
        pageController: pageController,
        current: current,
        name: group,
      ),
    );
  }

  void process(
      String user,
      String selectedEmail,
      String selectedPassword,
      String? selectedGroup,
      String? selectedGroupID,
      String? selectedDivisionID,
      String? selectedRegionID,
      String? username,
      String selectedPosition) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
   /* await AuthService().registerAdmins(
        user,
        selectedEmail,
        selectedPassword,
        "group",
        selectedPosition,
        selectedGroupID,
        selectedGroup,
        [selectedRegionID, "", selectedDivisionID, ""]).then((value) {
      if (value.status == "success") {
        setState(() {
          saved = true;
        });
        Timer(Duration(milliseconds: 1000), () {
          setState(() {
            addRegion = false;
            loading = false;
            saved = false;
            email.text = "";
            password.text = "";
            name.text = "";
            position.text = "";
          });
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
