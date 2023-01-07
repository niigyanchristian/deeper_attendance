import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../components/widgets.dart';
import '../controllers/blocs.dart';
import '../controllers/cloud.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../functions/app.dart';
import '../models/app.dart';
import '../models/cloud.dart';
import '../models/local.dart';
import '../pages/interval.dart';
import '../pages/review.dart';
import '../services/cloud.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';
import 'input.dart';

class Dashboard extends StatefulWidget with PageState {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  CloudCtx cloudCtx = Get.find<CloudCtx>();
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime dateCheck =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final List _services = [
    "All Services",
    "Sundays",
    "Revivals",
    "Bibles",
    "Others"
  ];
  String doc = "";
  String ser = "";
  bool loading = false;

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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    Local local = Provider.of<Local>(context);
    CurrentUser user = local.user("user")!;
    TextStyling textStyling = themes.textStyling;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GetX<CloudCtx>(
          init: cloudCtx,
          builder: (CloudCtx cloudCtx) {
            return Stack(
              children: [
                SizedBox(
                  height: height,
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
                                  Text(user.username!,
                                      style: textStyling.bold16),
                                  user.profile == "national" ||
                                          user.profile == ""
                                      ? const SizedBox.shrink()
                                      : Container(
                                          decoration: themes.foreground,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          margin:
                                              const EdgeInsets.only(left: 10),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          margin: const EdgeInsets.only(bottom: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  cloudCtx.addSelected(
                                    SelectedSection(
                                      areaID: user.areaID,
                                      area: user.area,
                                      type: user.profile,
                                      isSection: true,
                                    ),
                                  );
                                  Get.to(() => const Intervals());
                                },
                                child: Container(
                                  decoration: themes.foreground.copyWith(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 46,
                                  width: 46,
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: theme.primary,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Container(
                                width: width - 100,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: themes.foreground,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.chevron_left_rounded,
                                        color: theme.primary,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          today = today.subtract(
                                              const Duration(days: 1));
                                        });
                                      },
                                    ),
                                    Column(
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
                                    IconButton(
                                      icon: Icon(
                                        Icons.chevron_right_rounded,
                                        color: theme.primary,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          today = today
                                              .add(const Duration(days: 1));
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        buildServiceOptions(
                            width, textStyling, user, cloudCtx, themes),
                        SizedBox(
                          width: width,
                          height: 175,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                ValueBoxGender(
                                  title: "Attendance",
                                  valueMale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["attendance"]["male"])}",
                                  valueFemale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["attendance"]["female"])}",
                                  total:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["attendance"]["total"])}",
                                ),
                                ValueBoxGender(
                                  title: "Adults",
                                  valueMale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["adults"]["male"])}",
                                  valueFemale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["adults"]["female"])}",
                                  total:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["adults"]["total"])}",
                                ),
                                ValueBoxGender(
                                  title: "Youths",
                                  valueMale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["youth"]["male"])}",
                                  valueFemale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["youth"]["female"])}",
                                  total:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["youth"]["total"])}",
                                ),
                                ValueBoxGender(
                                  title: "Children",
                                  valueMale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["children"]["male"])}",
                                  valueFemale:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["children"]["female"])}",
                                  total:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["categories"]["children"]["total"])}",
                                ),
                                ValueBox(
                                  title: "Newcomers",
                                  value:
                                      "${fxn.calcAdd(todaySer(today, cloudCtx)["attendance"]["newcomers"])}",
                                ),
                                OfferBox(
                                    title: "Offering",
                                    value:
                                        "${fxn.calcAdd(todaySer(today, cloudCtx)["offers"]["one"])}"),
                                user.profile == "location" ||
                                        user.profile == "reviewer"
                                    ? OfferBox(
                                        title: "2nd Offering",
                                        value:
                                            "${fxn.calcAdd(todaySer(today, cloudCtx)["offers"]["two"])}")
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 20, bottom: 20, right: 15),
                          child: Row(
                            children: [
                              Text(
                                "Year So Far",
                                style: textStyling.bold16,
                              ),
                              const Spacer(),
                              Container(
                                decoration: themes.foreground,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                child: PopupMenuButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: theme.card,
                                  onSelected: (String value) {
                                    setState(() {});
                                    cloudCtx.changeService(value);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        cloudCtx.service,
                                        style: textStyling.bold14,
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: theme.primary,
                                        size: 20,
                                      )
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                      _service(context, textStyling),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          runSpacing: 15,
                          children: [
                            ValueBoxGenderAll(
                              title: "Attendance",
                              valueMale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["attendance"]["male"])}",
                              valueFemale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["attendance"]["female"])}",
                              total:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["attendance"]["total"])}",
                            ),
                            ValueBoxGenderAll(
                              title: "Adults",
                              valueMale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["adults"]["male"])}",
                              valueFemale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["adults"]["female"])}",
                              total:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["adults"]["total"])}",
                            ),
                            ValueBoxGenderAll(
                              title: "Youths",
                              valueMale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["youth"]["male"])}",
                              valueFemale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["youth"]["female"])}",
                              total:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["youth"]["total"])}",
                            ),
                            ValueBoxGenderAll(
                              title: "Children",
                              valueMale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["children"]["male"])}",
                              valueFemale:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["children"]["female"])}",
                              total:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["categories"]["children"]["total"])}",
                            ),
                            ValueBoxAll(
                              title: "Newcomers",
                              value:
                                  "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["attendance"]["newcomers"])}",
                            ),
                            OfferBoxAll(
                                title: "Offering",
                                value:
                                    "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["offers"]["one"])}"),
                            user.profile == "location" ||
                                    user.profile == "reviewer"
                                ? OfferBoxAll(
                                    title: "2nd Offering",
                                    value:
                                        "${fxn.calcAdd(serChg(cloudCtx.service, cloudCtx)["offers"]["two"])}")
                                : const SizedBox.shrink(),
                          ],
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Container buildServiceOptions(double width, TextStyling textStyling,
      CurrentUser user, CloudCtx cloudCtx, AppThemes themes) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      child: Row(
        children: [
          Text(
            fxn.event(today),
            style: textStyling.bold17,
          ),
          const Spacer(),
          (dateCheck.difference(today).inHours == 24 ||
                      dateCheck.difference(today).inHours == 0) &&
                  user.profile == "location" &&
                  isInserted(today, cloudCtx, user)
              ? GestureDetector(
                  onTap: () {
                    Get.to(() => Input(today: today));
                    /* setState(() => loading = true);
                    for (BibleModel sunday in cloudCtx.bib) {
                      Cloud()
                          .change(
                            adults: sunday.adults!,
                            youth: sunday.youth!,
                            children: sunday.children!,
                            newcomers: sunday.newcomers!,
                            offerings: sunday.offerings!,
                            sermon: sunday.sermon!,
                            remarks: sunday.remarks!,
                            month: sunday.month!,
                            year: sunday.year!,
                            attendants: sunday.attendants!,
                            service: "bibles",
                            datetime: sunday.datetime!,
                            review: sunday.review!,
                            regionID: sunday.regionID!,
                            divisionID: sunday.divisionID!,
                            groupID: sunday.groupID!,
                            localID: sunday.localID!,
                            doc: sunday.docID!,
                          )
                          .then((value) => setState(() => loading = false));
                    }*/
                  },
                  child: Container(
                    decoration: themes.foreground,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: loading
                        ? SpinKitPulse(
                            color: themes.appTheme.primary,
                            size: 15,
                          )
                        : Text(
                            "Add",
                            style: textStyling.bold14,
                          ),
                  ),
                )
              : const SizedBox.shrink(),
          (dateCheck.difference(today).inHours == 24 ||
                      dateCheck.difference(today).inHours == 0) &&
                  user.profile == "reviewer" &&
                  isReviewed(today, cloudCtx, user)
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Cloud().update("services",
                            serToday(today, cloudCtx, user).docID, user);
                      },
                      child: Container(
                        decoration: themes.foreground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Confirm",
                          style: textStyling.bold14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Review(
                            service: serToday(today, cloudCtx, user),
                            today: today));
                      },
                      child: Container(
                        decoration: themes.foreground,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Text(
                          "Edit",
                          style: textStyling.bold14,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Map<String, dynamic> todaySer(DateTime today, CloudCtx cloudCtx) {
    cloudCtx.changeDateAll(today);
    if (today.weekday == DateTime.sunday) {
      return cloudCtx.sSun;
    } else if (today.weekday == DateTime.monday) {
      return cloudCtx.sBib;
    } else if (today.weekday == DateTime.thursday) {
      return cloudCtx.sRev;
    } else {
      return cloudCtx.sOth;
    }
  }

  Map<String, dynamic> serChg(String service, CloudCtx cloudCtx) {
    switch (service) {
      case "All Services":
        return cloudCtx.allService;
      case "Sundays":
        return cloudCtx.sunday;
      case "Revivals":
        return cloudCtx.revival;
      case "Bibles":
        return cloudCtx.bible;
      case "Others":
        return cloudCtx.other;
      default:
        return cloudCtx.allService;
    }
  }

  bool isInserted(DateTime today, CloudCtx cloudCtx, CurrentUser user) {
    switch (fxn.event(today)) {
      case "Sunday Service":
        return cloudCtx.sundays
            .where((ele) =>
                fxn.changeDate(ele.datetime!.toDate()) == today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID)
            .isEmpty;
      case "Revival Service":
        return cloudCtx.revivals
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID)
            .isEmpty;
      case "Bible Service":
        return cloudCtx.bibles
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID)
            .isEmpty;
      case "Other Service":
        return cloudCtx.others
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID)
            .isEmpty;
      default:
        return cloudCtx.sundays
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID)
            .isEmpty;
    }
  }

  bool isReviewed(DateTime today, CloudCtx cloudCtx, CurrentUser user) {
    switch (fxn.event(today)) {
      case "Sunday Service":
        return cloudCtx.sundays
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .isNotEmpty;
      case "Revival Service":
        return cloudCtx.revivals
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .isNotEmpty;
      case "Bible Service":
        return cloudCtx.bibles
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .isNotEmpty;
      case "Other Service":
        return cloudCtx.others
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .isNotEmpty;
      default:
        return cloudCtx.sundays
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .isNotEmpty;
    }
  }

  ServiceModel serToday(DateTime today, CloudCtx cloudCtx, CurrentUser user) {
    switch (fxn.event(today)) {
      case "Sunday Service":
        return cloudCtx.sundays
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .last;
      case "Revival Service":
        return cloudCtx.revivals
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .last;
      case "Bible Service":
        return cloudCtx.bibles
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .last;
      case "Other Service":
        return cloudCtx.others
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .last;
      default:
        return cloudCtx.sundays
            .where((ele) =>
                fxn.changeDate(ele.datetime == null
                        ? today
                        : ele.datetime!.toDate()) ==
                    today &&
                cloudCtx.wr(ele, user.profile!) == user.areaID &&
                ele.review == false)
            .last;
    }
  }

  List<PopupMenuItem<String>> _service(
      BuildContext context, TextStyling textStyling) {
    List<PopupMenuItem<String>> popupMenuItems = [];
    for (String service in _services) {
      popupMenuItems.add(PopupMenuItem(
        value: service,
        child: Text(
          service,
          style: textStyling.medium16,
        ),
      ));
    }

    return popupMenuItems;
  }
}
