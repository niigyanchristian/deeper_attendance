import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/alert.dart';
import '../../components/widgets.dart';
import '../../controllers/theme.dart';
import '../../models/cloud.dart';
import '../../styles/colours.dart';
import '../../styles/texts.dart';

class LocalUser extends StatefulWidget {
  final List<Admin>? admin;

  const LocalUser({Key? key, this.admin}) : super(key: key);

  @override
  State<LocalUser> createState() => _LocalUserState();
}

class _LocalUserState extends State<LocalUser> with TickerProviderStateMixin {
  late AnimationController _controller;
  PageController? pageController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? selectedLocal = "";
  String? selectedLocalID = "";
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    bool isDark = themes.theme!;
    TextStyling textStyling = themes.textStyling;
    List<LocalModel> localsModel = Provider.of<List<LocalModel>>(context);
    List<LocalModel> locals = localsModel
        .where((element) => element.groupID == widget.admin!.first.areaID)
        .toList();

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
                      const SizedBox(height: 45),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(right: 20, left: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondary,
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(0.2),
                                  offset: const Offset(0.0, 10.0),
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
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Column(
                        children: [
                          Text(
                            "Locals",
                            style: textStyling.bold25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 65, vertical: 20),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: textStyling.regular16,
                                children: const [
                                  TextSpan(
                                    text: "Available locals for this group",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        height: 275,
                        child: PageView(
                          pageSnapping: true,
                          physics: const ClampingScrollPhysics(),
                          controller: pageController,
                          children: [
                            for (int i = 0; i < locals.length; i++)
                              local(
                                  locals[i].name,
                                  locals[i].documentID,
                                  locals[i].groupID,
                                  locals[i].divisionID,
                                  locals[i].regionID,
                                  i,
                                  screenWidth,
                                  textStyling),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
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
                duration: const Duration(milliseconds: 1200),
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
                        const SizedBox(height: 45),
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  addRegion = false;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                margin:
                                    const EdgeInsets.only(right: 20, left: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: theme.secondary,
                                  boxShadow: [
                                    BoxShadow(
                                      color: black.withOpacity(0.7),
                                      offset: const Offset(0.0, 5.0),
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
                          padding: const EdgeInsets.only(
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
                          padding: const EdgeInsets.only(
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
                          padding: const EdgeInsets.only(
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
                          padding: const EdgeInsets.only(
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
                                  selectedLocal,
                                  selectedLocalID,
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
                            margin: const EdgeInsets.only(top: 30, bottom: 30),
                            decoration: BoxDecoration(
                              color: theme.secondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: black.withOpacity(isDark ? 0.6 : 0.5),
                                  offset: const Offset(0.0, 6.0),
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
                                      : SizedBox(
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

  Widget local(
    String? local,
    String? localID,
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
          selectedLocalID = localID;
          selectedGroupID = groupID;
          selectedDivisionID = divisionID;
          selectedRegionID = regionID;
          selectedLocal = local;
        });
      },
      child: PageViewItems(
        pageController: pageController,
        current: current,
        name: local,
      ),
    );
  }

  void process(
      String user,
      String selectedEmail,
      String selectedPassword,
      String? selectedLocal,
      String? selectedLocalID,
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
        "location",
        selectedPosition,
        selectedLocalID,
        selectedLocal,
        [selectedRegionID, "", selectedDivisionID, "", selectedGroupID, ""]).then((value) {
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
