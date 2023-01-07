import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/widgets.dart';
import '../../controllers/blocs.dart';
import '../../controllers/cloud.dart';
import '../../controllers/theme.dart';
import '../../database/local.dart';
import '../../functions/app.dart';
import '../../models/local.dart';
import '../../styles/colours.dart';
import '../../styles/texts.dart';
import '../interval.dart';

class SelectedLocation extends StatefulWidget with PageState {
  const SelectedLocation({
    Key? key,
  }) : super(key: key);

  @override
  State<SelectedLocation> createState() => _SelectedLocationState();
}

class _SelectedLocationState extends State<SelectedLocation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  CloudCtx cloudCtx = Get.find<CloudCtx>();
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final List _services = [
    "All Services",
    "Sundays",
    "Revivals",
    "Bibles",
    "Others"
  ];

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

    return WillPopScope(
      onWillPop: () => fxn.selectedBack(cloudCtx, context),
      child: Scaffold(
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: GetX<CloudCtx>(
              init: cloudCtx,
              builder: (CloudCtx cloudCtx) {
                return SizedBox(
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
                                  Container(
                                    decoration: themes.foreground,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          cloudCtx.section.type!
                                              .toCapitalization(),
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
                                          cloudCtx.section.area!,
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 20,
                            bottom: 0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                event(today),
                                style: textStyling.bold17,
                              ),
                            ],
                          ),
                        ),
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
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Map<String, dynamic> todaySer(DateTime today, CloudCtx cloudCtx) {
    cloudCtx.changeDate(today);
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
    cloudCtx.addSelected(cloudCtx.section);
    switch (service) {
      case "All Services":
        return cloudCtx.seAll;
      case "Sundays":
        return cloudCtx.seSun;
      case "Revivals":
        return cloudCtx.seRev;
      case "Bibles":
        return cloudCtx.seBib;
      case "Others":
        return cloudCtx.seOth;
      default:
        return cloudCtx.seAll;
    }
  }

  String event(
    DateTime today,
  ) {
    if (today.weekday == DateTime.sunday) {
      return "Sunday Service";
    } else if (today.weekday == DateTime.monday) {
      return "Bible Service";
    } else if (today.weekday == DateTime.thursday) {
      return "Revival Service";
    } else {
      return "Other Service";
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
