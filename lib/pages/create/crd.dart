import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/alert.dart';
import '../../components/widgets.dart';
import '../../controllers/theme.dart';
import '../../models/cloud.dart';
import '../../services/cloud.dart';
import '../../styles/colours.dart';
import '../../styles/texts.dart';

class CreateDivision extends StatefulWidget {
  final List<Admin>? admin;

  const CreateDivision({Key? key, this.admin}) : super(key: key);

  @override
  State<CreateDivision> createState() => _CreateDivisionState();
}

class _CreateDivisionState extends State<CreateDivision>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  PageController? pageController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  String? selectedRegion = "";
  String? selectedRegionID = "";
  bool addDivision = false;
  String division = "";
  bool loading = false;
  bool saved = false;
  bool error = false;
  String? errorMessage = "";
  TextEditingController divisionController = TextEditingController();

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
    List<RegionModel> regions = Provider.of<List<RegionModel>>(context);

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
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Regions",
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
                                    text: "Select a region to add a division",
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
                            for (int i = 0; i < regions.length; i++)
                              region(regions[i].name, regions[i].regionID, i,
                                  screenWidth, textStyling),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              addDivision
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
                top: addDivision ? -150 : -510,
                child: Container(
                  height: 450,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.15),
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 15,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 45),
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Selected Region",
                                  style: textStyling.medium13,
                                ),
                                Text(
                                  selectedRegion!,
                                  style: textStyling.bold18,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                addDivision = false;
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
                          bottom: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Add New Division",
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
                              process(value, widget.admin!.first.profile,
                                  selectedRegionID);
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
                            division = value;
                          },
                          keyboardType: TextInputType.text,
                          style: textStyling.medium16,
                          cursorColor: theme.secondary,
                          controller: divisionController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'division',
                            hintStyle: textStyling.bold18,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (division != "") {
                            process(division, widget.admin!.first.profile,
                                selectedRegionID);
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

  Widget region(String? region, String? regionID, int current,
      double screenWidth, TextStyling textStyling) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRegion = region;
          selectedRegionID = regionID;
          addDivision = true;
        });
      },
      child: PageViewItems(
        pageController: pageController,
        current: current,
        name: region,
      ),
    );
  }

  process(String value, String? creator, String? regionID) async {
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
    });
    await Cloud().addDivision(value, regionID, creator).then((value) {
      if (value.status == "success") {
        setState(() {
          saved = true;
          divisionController.text = "";
          division = "";
        });
        Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            addDivision = false;
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
