import 'dart:async';

import 'package:deeper/components/alert.dart';
import 'package:deeper/components/widgets.dart';
import 'package:deeper/controllers/theme.dart';
import 'package:deeper/models/cloud.dart';
import 'package:deeper/services/cloud.dart';
import 'package:deeper/styles/colours.dart';
import 'package:deeper/styles/texts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateRegion extends StatefulWidget {
  final List<Admin>? admin;

  const CreateRegion({Key? key, this.admin}) : super(key: key);
  @override
  _CreateRegionState createState() => _CreateRegionState();
}

class _CreateRegionState extends State<CreateRegion> with TickerProviderStateMixin {
  late AnimationController _controller;
  PageController? pageController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String selectedRegion = "";
  bool addRegion = false;
  String regionInput = "";
  bool error = false;
  String? errorMessage = "";
  bool loading = false;
  bool saved = false;
  List<RegionModel>? regions;

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
                              icon: Icon(Icons.arrow_back, color: white, size: 22,),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                addRegion = true;
                              });
                            },
                            child: Container(
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
                              child: Icon(Icons.add, color: white, size: 22,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25),
                      Column(
                        children: [
                          Text(
                            "Region",
                            style: textStyling.bold25,
                          ),
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 65, vertical: 20),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: textStyling.regular16,
                                children: [
                                  TextSpan(
                                    text:
                                    "Available regions of the church",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 35),
                      StreamProvider<List<RegionModel>>.value(
                        value: Cloud().regions,
                        initialData: [],
                        child: AllRegions(pageController: pageController,),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              addRegion ? Container(
                height: screenHeight,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.2),
                ),
              ) : Container(),
              AnimatedPositioned(
                duration: Duration(milliseconds: 1200),
                curve: Curves.elasticOut,
                left: 0,
                right: 0,
                top: addRegion ? -150 : -510,
                child: Container(
                  height: 450,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
                                child: Icon(Icons.close, color: white, size: 22,),
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
                                "Add New Region",
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
                                process(value, widget.admin!.first.username);
                              } else {
                                setState(() {
                                  error = true;
                                  errorMessage = "Field cannot be empty on submit";
                                  _errorTimer();
                                });
                              }
                            },
                            onChanged: (value) {
                              regionInput = value;
                            },
                            keyboardType: TextInputType.text,
                            style: textStyling.medium16,
                            cursorColor: theme.secondary,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'region',
                              hintStyle: textStyling.bold18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if(regionInput != "") {
                              process(regionInput, widget.admin!.first.username);
                            } else {
                              setState(() {
                                error = true;
                                errorMessage = "Field cannot be empty on submit";
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
                                      "Insert Region",
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
              Errors(error: error, errorMessage: errorMessage,),
            ],
          ),
        ),
      ),
    );
  }

  process(String value, String? creator) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
   await Cloud().addRegion(value, creator).then((value) {
     if(value.status == "success") {
       setState(() {
         saved = true;
       });
       Timer(Duration(milliseconds: 1000), () {
         setState(() {
           addRegion = false;
           loading = false;
           saved = false;
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

class AllRegions extends StatefulWidget {
  final PageController? pageController;

  const AllRegions({Key? key, this.pageController}) : super(key: key);
  @override
  _AllRegionsState createState() => _AllRegionsState();
}

class _AllRegionsState extends State<AllRegions> {


  @override
  Widget build(BuildContext context) {
    List<RegionModel> regions = Provider.of<List<RegionModel>>(context);
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
          for (int i = 0; i < regions.length; i++)
            region(regions[i].name, i, screenWidth,
                textStyling),
        ],
      ),
    );
  }

  Widget region(String? region, int current, double screenWidth,
      TextStyling textStyling) {
    return GestureDetector(
      onTap: () {
      },
      child: PageViewItems(
        pageController: widget.pageController,
        current: current,
        name: region,
      ),
    );
  }
}




