import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../components/alert.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../functions/app.dart';
import '../models/local.dart';
import '../services/cloud.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class Review extends StatefulWidget {
  final dynamic service;
  final DateTime today;

  const Review({Key? key, required this.service, required this.today})
      : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  TextEditingController adultMale = TextEditingController();
  TextEditingController adultFemale = TextEditingController();
  TextEditingController youthMale = TextEditingController();
  TextEditingController youthFemale = TextEditingController();
  TextEditingController childrenMale = TextEditingController();
  TextEditingController childrenFemale = TextEditingController();
  TextEditingController comers = TextEditingController();
  TextEditingController offers1Controller = TextEditingController();
  TextEditingController offers2Controller = TextEditingController();
  TextEditingController expensesController = TextEditingController();
  TextEditingController speakerController = TextEditingController();
  TextEditingController topicController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  late DateTime today;
  Cloud cloud = Cloud();

  late List attendants;
  double? offering;
  late List adults;
  late List youth;
  late List children;
  late List offerings;
  late List sermon;
  late String expense;
  late String remarks;
  bool error = false;
  String? errorMessage = "";
  bool loading = false;
  bool saved = false;
  bool deleting = false;
  bool deleted = false;
  late dynamic ser;

  @override
  void initState() {
    ser = widget.service;
    today = widget.today;
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
    init();
    super.initState();
  }

  void init() {
    attendants = [
      ser.attendants,
      (ser.adults![0] + ser.adults![1]),
      (ser.youth![0] + ser.youth![1]),
      (ser.children![0] + ser.children![1]),
      ser.newcomers
    ];
    adults = ser.adults!;
    children = ser.children!;
    youth = ser.youth!;
    offerings = ser.offerings!;
    sermon = ser.sermon!;
    remarks = ser.remarks!;
    adultMale.text = adults[0].toString();
    adultFemale.text = adults[1].toString();
    youthMale.text = youth[0].toString();
    youthFemale.text = youth[1].toString();
    childrenMale.text = children[0].toString();
    childrenFemale.text = children[1].toString();
    comers.text = attendants[4].toString();
    offers1Controller.text = offerings[0].toString();
    offers2Controller.text = offerings[1].toString();
    expensesController.text = offerings[2].toString();
    speakerController.text = sermon[0];
    topicController.text = sermon[1];
    remarksController.text = remarks;
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

  _errorTimer() {
    Timer(const Duration(milliseconds: 4000), () {
      error
          ? setState(() {
              error = false;
            })
          : setState(() {});
    });
  }

  successTimer() {
    Timer(const Duration(milliseconds: 1000), () {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    bool isDark = themes.theme!;
    TextStyling textStyling = themes.textStyling;
    Local local = Provider.of<Local>(context);
    CurrentUser user = local.user("user")!;

    return Scaffold(
      backgroundColor: isDark ? black : theme.background,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: height,
          width: width,
          color: isDark ? white.withOpacity(0.1) : transparent,
          child: Stack(
            children: [
              SizedBox(
                width: width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 45),
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
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
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 15,
                        children: [
                          Container(
                            width: 160,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration: themes.foreground,
                            child: Column(
                              children: [
                                Text(
                                  today.formatDay(),
                                  style: textStyling.bold15,
                                ),
                                Text(
                                  today.formatDateOnly(),
                                  style: textStyling.boldMuted13,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 160,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 10),
                            decoration: themes.foreground,
                            child: Column(
                              children: [
                                Text(
                                  fxn.event(today),
                                  style: textStyling.bold15,
                                ),
                                Text(
                                  "Event",
                                  style: textStyling.boldMuted13,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Offering",
                                      style: textStyling.mediumMuted14,
                                    ),
                                    Text(
                                      "${offerings[0]}",
                                      style: textStyling.bold22,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Total Attendance",
                                      style: textStyling.mediumMuted14,
                                    ),
                                    Text(
                                      "${attendants[0]}",
                                      style: textStyling.bold22,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Category Distribution",
                              style: textStyling.bold16,
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Adults",
                                      style: textStyling.bold16,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${attendants[1]}",
                                      style: textStyling.bold16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "male",
                                          style: textStyling.mediumMuted14,
                                        ),
                                        Container(
                                          width: 135,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (value) {
                                              int male = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int female = adults[1];
                                              int total = male + female;
                                              setState(() {
                                                adults[0] = male;
                                                attendants[1] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[3];
                                              });
                                            },
                                            onChanged: (value) {
                                              int male = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int female = adults[1];
                                              int total = male + female;
                                              setState(() {
                                                adults[0] = male;
                                                attendants[1] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[3];
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: adultMale,
                                            style: textStyling.medium18,
                                            cursorColor: theme.primary,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Males',
                                              hintStyle: textStyling.bold18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Female",
                                          style: textStyling.mediumMuted14,
                                        ),
                                        Container(
                                          width: 135,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (value) {
                                              int male = adults[0];
                                              int female = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int total = male + female;
                                              setState(() {
                                                adults[1] = female;
                                                attendants[1] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[3];
                                              });
                                            },
                                            onChanged: (value) {
                                              int male = adults[0];
                                              int female = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int total = male + female;
                                              setState(() {
                                                adults[1] = female;
                                                attendants[1] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[3];
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: adultFemale,
                                            style: textStyling.medium18,
                                            cursorColor: theme.primary,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Females',
                                              hintStyle: textStyling.bold18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Youths",
                                      style: textStyling.bold16,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${attendants[2]}",
                                      style: textStyling.bold16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "male",
                                          style: textStyling.mediumMuted14,
                                        ),
                                        Container(
                                          width: 135,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (value) {
                                              int male = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int female = youth[1];
                                              int total = male + female;
                                              setState(() {
                                                youth[0] = male;
                                                attendants[2] = total;
                                                attendants[0] = total +
                                                    attendants[1] +
                                                    attendants[3];
                                              });
                                            },
                                            onChanged: (value) {
                                              int male = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int female = youth[1];
                                              int total = male + female;
                                              setState(() {
                                                youth[0] = male;
                                                attendants[2] = total;
                                                attendants[0] = total +
                                                    attendants[1] +
                                                    attendants[3];
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: youthMale,
                                            style: textStyling.medium18,
                                            cursorColor: theme.primary,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Males',
                                              hintStyle: textStyling.bold18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Female",
                                          style: textStyling.mediumMuted14,
                                        ),
                                        Container(
                                          width: 135,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (value) {
                                              int male = youth[0];
                                              int female = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int total = male + female;
                                              setState(() {
                                                youth[1] = female;
                                                attendants[2] = total;
                                                attendants[0] = total +
                                                    attendants[1] +
                                                    attendants[3];
                                              });
                                            },
                                            onChanged: (value) {
                                              int male = youth[0];
                                              int female = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int total = male + female;
                                              setState(() {
                                                youth[1] = female;
                                                attendants[2] = total;
                                                attendants[0] = total +
                                                    attendants[1] +
                                                    attendants[3];
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: youthFemale,
                                            style: textStyling.medium18,
                                            cursorColor: theme.primary,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Females',
                                              hintStyle: textStyling.bold18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Children",
                                      style: textStyling.bold16,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${attendants[3]}",
                                      style: textStyling.bold16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "male",
                                          style: textStyling.mediumMuted14,
                                        ),
                                        Container(
                                          width: 135,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (value) {
                                              int male = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int female = children[1];
                                              int total = male + female;
                                              setState(() {
                                                children[0] = male;
                                                attendants[3] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[1];
                                              });
                                            },
                                            onChanged: (value) {
                                              int male = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int female = children[1];
                                              int total = male + female;
                                              setState(() {
                                                children[0] = male;
                                                attendants[3] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[1];
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: childrenMale,
                                            style: textStyling.medium18,
                                            cursorColor: theme.primary,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Males',
                                              hintStyle: textStyling.bold18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Female",
                                          style: textStyling.mediumMuted14,
                                        ),
                                        Container(
                                          width: 135,
                                          height: 45,
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (value) {
                                              int male = children[0];
                                              int female = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int total = male + female;
                                              setState(() {
                                                children[1] = female;
                                                attendants[3] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[1];
                                              });
                                            },
                                            onChanged: (value) {
                                              int male = children[0];
                                              int female = value != ""
                                                  ? int.parse(value)
                                                  : 0;
                                              int total = male + female;
                                              setState(() {
                                                children[1] = female;
                                                attendants[3] = total;
                                                attendants[0] = total +
                                                    attendants[2] +
                                                    attendants[1];
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: childrenFemale,
                                            style: textStyling.medium18,
                                            cursorColor: theme.primary,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Females',
                                              hintStyle: textStyling.bold18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Newcomers",
                                      style: textStyling.bold16,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "${attendants[4]}",
                                      style: textStyling.bold16,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "total new comers",
                                      style: textStyling.mediumMuted12,
                                    ),
                                    Container(
                                      width: 290,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.done,
                                        onFieldSubmitted: (value) {
                                          setState(() {
                                            attendants[4] = value != ""
                                                ? int.parse(value)
                                                : 0;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            attendants[4] = value != ""
                                                ? int.parse(value)
                                                : 0;
                                          });
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: comers,
                                        style: textStyling.medium18,
                                        cursorColor: theme.primary,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Value',
                                          hintStyle: textStyling.bold18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Offertories",
                              style: textStyling.bold16,
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: themes.foreground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "1st Offering",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Container(
                                  width: 160,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        offerings[0] = value != ""
                                            ? double.parse(value)
                                            : 0.0;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        offerings[0] = value != ""
                                            ? double.parse(value)
                                            : 0.0;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: offers1Controller,
                                    style: textStyling.medium18,
                                    cursorColor: theme.secondary,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '1st',
                                      hintStyle: textStyling.bold18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: themes.foreground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "2nd Offering",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Container(
                                  width: 160,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        offerings[1] = value != ""
                                            ? double.parse(value)
                                            : 0.0;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        offerings[1] = value != ""
                                            ? double.parse(value)
                                            : 0.0;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: offers2Controller,
                                    style: textStyling.medium18,
                                    cursorColor: theme.secondary,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '2nd',
                                      hintStyle: textStyling.bold18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 180,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            decoration: themes.foreground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Expenses",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Container(
                                  width: 160,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        offerings[2] = value != ""
                                            ? double.parse(value)
                                            : 0.0;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        offerings[2] = value != ""
                                            ? double.parse(value)
                                            : 0.0;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: expensesController,
                                    style: textStyling.medium18,
                                    cursorColor: theme.secondary,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Expense',
                                      hintStyle: textStyling.bold18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Sermon",
                              style: textStyling.bold16,
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Speaker",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Container(
                                  width: 340,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        sermon[0] = value;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        sermon[0] = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: speakerController,
                                    style: textStyling.medium16,
                                    cursorColor: theme.secondary,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Speaker',
                                      hintStyle: textStyling.bold18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 340,
                            decoration: themes.foreground,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Topic",
                                        style: textStyling.bold14,
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(height: 10),
                                Container(
                                  width: 340,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onFieldSubmitted: (value) {
                                      setState(() {
                                        sermon[1] = value;
                                      });
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        sermon[1] = value;
                                      });
                                    },
                                    keyboardType: TextInputType.text,
                                    controller: topicController,
                                    style: textStyling.medium16,
                                    cursorColor: theme.secondary,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Topic',
                                      hintStyle: textStyling.bold18,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Other",
                              style: textStyling.bold16,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 340,
                        decoration: themes.foreground,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 3.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Remarks",
                                    style: textStyling.bold14,
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 10),
                            Container(
                              width: 340,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                onFieldSubmitted: (value) {
                                  setState(() {
                                    remarks = value;
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {
                                    remarks = value;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                controller: remarksController,
                                style: textStyling.medium16,
                                cursorColor: theme.secondary,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'remarks',
                                  hintStyle: textStyling.bold18,
                                ),
                                textAlign: TextAlign.center,
                                minLines: 1,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          if (sermon[0] != "" && sermon[1] != "") {
                            setState(() => loading = true);
                            cloud
                                .edited(
                                    adults,
                                    youth,
                                    children,
                                    attendants[4],
                                    offerings,
                                    sermon,
                                    remarks,
                                    user,
                                    attendants[0],
                                    fxn.eventCol(today),
                                    ser.docID!)
                                .then((value) {
                              if (value.status == "success") {
                                setState(() {
                                  saved = true;
                                });
                                successTimer();
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                if (error) {
                                  errorMessage = value.error!.message;
                                } else {
                                  setState(() {
                                    error = true;
                                    errorMessage = value.error!.message;
                                  });
                                  _errorTimer();
                                }
                              }
                            });
                          } else {
                            setState(() {
                              error = true;
                              errorMessage =
                                  "Sermon field or Topic field can't be empty";
                              loading = false;
                            });
                            _errorTimer();
                          }
                        },
                        child: Container(
                          height: 45,
                          width: 290,
                          margin: const EdgeInsets.only(bottom: 60),
                          decoration: BoxDecoration(
                            color: theme.secondary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: black.withOpacity(isDark ? 0.6 : 0.2),
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
                                        size: 25,
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
                                    "Update Now",
                                    style: textStyling.boldWhite16,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      deleting = true;
                    });
                    Cloud().delete("services", ser.docID).then((value) {
                      if (value.status == "success") {
                        setState(() {
                          deleted = true;
                        });
                        Timer(const Duration(milliseconds: 1500), () {
                          Get.back();
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: themes.foreground.copyWith(color: red),
                    width: 100,
                    height: 35,
                    margin: const EdgeInsets.only(bottom: 15, right: 15),
                    child: Center(
                      child: deleting
                          ? deleted
                              ? Icon(
                                  Icons.check,
                                  color: white,
                                  size: 25,
                                )
                              : SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    backgroundColor: white,
                                  ),
                                )
                          : Text(
                              "Delete Data",
                              style: textStyling.boldWhite14,
                            ),
                    ),
                  ),
                ),
              ),
              Errors(error: error, errorMessage: errorMessage),
            ],
          ),
        ),
      ),
    );
  }
}
