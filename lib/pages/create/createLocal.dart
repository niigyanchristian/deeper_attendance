import 'dart:async';

import 'package:deeper/components/widgets.dart';
import 'package:deeper/controllers/theme.dart';
import 'package:deeper/models/cloud.dart';
import 'package:deeper/services/cloud.dart';
import 'package:deeper/styles/colours.dart';
import 'package:deeper/styles/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateLocal extends StatefulWidget {
  final List<Admin>? admin;

  const CreateLocal({Key? key, this.admin}) : super(key: key);

  @override
  _CreateLocalState createState() => _CreateLocalState();
}

class _CreateLocalState extends State<CreateLocal>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  PageController? pageController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool addLocal = false;
  TextEditingController groupController = TextEditingController();
  String selectedGroup = "";
  bool error = false;
  String? errorMessage = "";
  bool loading = false;
  bool saved = false;

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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                addLocal = true;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: EdgeInsets.only(right: 15),
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
                              child: Icon(
                                Icons.add,
                                color: white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Column(
                        children: [
                          Text(
                            "Locals",
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
                                    text:
                                        "Below are the registered Locals for this division",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35),
                      StreamProvider<List<LocalModel>>.value(
                        value: Cloud().locals,
                        initialData: [],
                        child: AllLocal(
                            pageController: pageController,
                            admin: widget.admin),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              addLocal
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
                top: addLocal ? -150 : -510,
                child: Container(
                  height: 450,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.15),
                        offset: Offset(0.0, 0.0),
                        blurRadius: 15,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Container(
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
                                  addLocal = false;
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
                            bottom: 20,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Add New Local",
                                style: textStyling.medium16,
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
                                process(
                                  value,
                                  widget.admin!.first.profile,
                                  widget.admin!.first.others![0],
                                  widget.admin!.first.others![2],
                                  widget.admin!.first.areaID,
                                );
                              } else {
                                setState(() {
                                  error = true;
                                  errorMessage =
                                      "Field cannot be empty on submission";
                                });
                                _errorTimer();
                              }
                            },
                            onChanged: (value) {
                              selectedGroup = value;
                            },
                            keyboardType: TextInputType.text,
                            style: textStyling.medium16,
                            cursorColor: theme.secondary,
                            controller: groupController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'local',
                              hintStyle: textStyling.bold18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selectedGroup != "") {
                              process(
                                selectedGroup,
                                widget.admin!.first.profile,
                                widget.admin!.first.others![0],
                                widget.admin!.first.others![2],
                                widget.admin!.first.areaID,
                              );
                            } else {
                              setState(() {
                                error = true;
                                errorMessage =
                                    "Field cannot be empty on submission";
                              });
                              _errorTimer();
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
            ],
          ),
        ),
      ),
    );
  }

  process(String value, String? creator, String regionID, String divisionID,
      String? groupID) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    await Cloud()
        .addLocal(value, groupID, divisionID, regionID, creator)
        .then((value) {
      if (value.status == "success") {
        setState(() {
          saved = true;
        });
        Timer(Duration(milliseconds: 1000), () {
          setState(() {
            addLocal = false;
            loading = false;
            saved = false;
            groupController.text = "";
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
    });
  }
}

class AllLocal extends StatefulWidget {
  final PageController? pageController;
  final List<Admin>? admin;

  const AllLocal({Key? key, this.pageController, this.admin}) : super(key: key);

  @override
  _AllLocalState createState() => _AllLocalState();
}

class _AllLocalState extends State<AllLocal> {
  @override
  Widget build(BuildContext context) {
    List<LocalModel> localsModel = Provider.of<List<LocalModel>>(context);
    List<LocalModel> locals = localsModel
        .where((element) => element.groupID == widget.admin!.first.areaID)
        .toList();
    double screenWidth = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;

    return Container(
      height: 275,
      child: PageView(
        pageSnapping: true,
        physics: ClampingScrollPhysics(),
        controller: widget.pageController,
        children: [
          for (int i = 0; i < locals.length; i++)
            local(locals[i].name, i, screenWidth, textStyling),
        ],
      ),
    );
  }

  Widget local(
      String? local, int current, double screenWidth, TextStyling textStyling) {
    return GestureDetector(
      onTap: () {},
      child: PageViewItems(
        pageController: widget.pageController,
        current: current,
        name: local,
      ),
    );
  }
}
