import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/widgets.dart';
import '../controllers/cloud.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../functions/app.dart';
import '../models/cloud.dart';
import '../models/local.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class Intervals extends StatefulWidget {
  const Intervals({
    Key? key,
  }) : super(key: key);

  @override
  State<Intervals> createState() => _IntervalsState();
}

class _IntervalsState extends State<Intervals>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  CloudCtx cloudCtx = Get.find<CloudCtx>();
  DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String selService = "All Services";
  String filter = "Year";
  String month = "January";
  String year = DateFormat("y").format(DateTime.now());
  late DateTime begin;
  late DateTime end;
  bool range = false;
  final List _services = [
    "All Services",
    "Sundays",
    "Revivals",
    "Bibles",
    "Others"
  ];

  final List _filters = [
    "Year",
    "Month",
    "Date Range",
  ];

  @override
  void initState() {
    begin = today;
    end = today;
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

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            GetX<CloudCtx>(
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
                                    cloudCtx.section.type != "national"
                                        ? Container(
                                            decoration: themes.foreground,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  cloudCtx.section.type!
                                                      .toCapitalization(),
                                                  style: textStyling.bold12,
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
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
                                            cloudCtx.section.type == "national"
                                                ? "National"
                                                : cloudCtx.section.area!,
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
                          filter == "Date Range"
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      range = true;
                                    });
                                  },
                                  child: Container(
                                    width: 340,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    margin: const EdgeInsets.only(bottom: 15),
                                    decoration: themes.foreground,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              begin.formatDay(),
                                              style: textStyling.bold15,
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              begin.formatDateOnly(),
                                              style: textStyling.boldMuted13,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "-",
                                          style: textStyling.bold15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              end.formatDay(),
                                              style: textStyling.bold15,
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              end.formatDateOnly(),
                                              style: textStyling.boldMuted13,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 15, bottom: 20, right: 15),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    Container(
                                      decoration: themes.foreground,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        color: theme.card,
                                        onSelected: (String value) {
                                          setState(() {
                                            filter = value;
                                            if (value == "Date Range") {
                                              range = true;
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "filter | $filter",
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
                                            _filter(context, textStyling),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Spacer(),
                                    filter == "Month"
                                        ? Container(
                                            decoration: themes.foreground,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              color: theme.card,
                                              onSelected: (String value) {
                                                setState(() {
                                                  month = value;
                                                });
                                                cloudCtx.changeMonth(
                                                    month, year);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    month,
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
                                              itemBuilder: (BuildContext
                                                      context) =>
                                                  _month(context, textStyling),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    filter != "Date Range"
                                        ? Container(
                                            decoration: themes.foreground,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: PopupMenuButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              color: theme.card,
                                              onSelected: (String value) {
                                                setState(() {
                                                  year = value;
                                                });
                                                cloudCtx.changeYear(year);
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    year,
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
                                              itemBuilder: (BuildContext
                                                      context) =>
                                                  _year(context, textStyling),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    Container(
                                      decoration: themes.foreground,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      child: PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        color: theme.card,
                                        onSelected: (String value) {
                                          setState(() {
                                            selService = value;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              selService,
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
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["attendance"]["male"])}",
                                valueFemale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["attendance"]["female"])}",
                                total:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["attendance"]["total"])}",
                              ),
                              ValueBoxGenderAll(
                                title: "Adults",
                                valueMale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["adults"]["male"])}",
                                valueFemale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["adults"]["female"])}",
                                total:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["adults"]["total"])}",
                              ),
                              ValueBoxGenderAll(
                                title: "Youths",
                                valueMale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["youth"]["male"])}",
                                valueFemale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["youth"]["female"])}",
                                total:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["youth"]["total"])}",
                              ),
                              ValueBoxGenderAll(
                                title: "Children",
                                valueMale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["children"]["male"])}",
                                valueFemale:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["children"]["female"])}",
                                total:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["categories"]["children"]["total"])}",
                              ),
                              ValueBoxAll(
                                title: "Newcomers",
                                value:
                                    "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["attendance"]["newcomers"])}",
                              ),
                              OfferBoxAll(
                                  title: "Offering",
                                  value:
                                      "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["offers"]["one"])}"),
                              user.profile == "location" ||
                                      user.profile == "reviewer"
                                  ? OfferBoxAll(
                                      title: "2nd Offering",
                                      value:
                                          "${fxn.calcAdd(serChg(selService, cloudCtx, filter)["offers"]["two"])}")
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  );
                }),
            Stack(
              children: [
                range
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            range = false;
                          });
                        },
                        child: Container(
                          height: height,
                          width: width,
                          decoration: BoxDecoration(
                              color:
                                  black.withOpacity(themes.isDark ? 0.5 : 0.3)),
                        ),
                      )
                    : Container(),
                AnimatedPositioned(
                  top: range ? 0 : height,
                  bottom: range ? 0 : -height,
                  left: 0,
                  right: 0,
                  duration: const Duration(milliseconds: 1400),
                  curve: Curves.elasticOut,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Center(
                      child: Container(
                        width: 340,
                        height: 400,
                        decoration:
                            themes.pops.copyWith(color: theme.background),
                        child: SfDateRangePicker(
                          selectionMode: DateRangePickerSelectionMode.range,
                          initialSelectedRange: PickerDateRange(
                            DateTime.now().subtract(const Duration(days: 4)),
                            DateTime.now(),
                          ),
                          rangeSelectionColor: themes.isDark ? white : darkCard,
                          endRangeSelectionColor:
                              themes.isDark ? white : darkCard,
                          startRangeSelectionColor:
                              themes.isDark ? white : darkCard,
                          selectionTextStyle: textStyling.bold13!.copyWith(
                            color: themes.isDark ? primary : white,
                          ),
                          rangeTextStyle: textStyling.bold13!.copyWith(
                            color: themes.isDark ? primary : white,
                          ),
                          headerStyle: DateRangePickerHeaderStyle(
                              textStyle: textStyling.bold14),
                          monthCellStyle: DateRangePickerMonthCellStyle(
                              textStyle: textStyling.boldMuted12),
                          yearCellStyle: DateRangePickerYearCellStyle(
                              textStyle: textStyling.boldMuted12),
                          showActionButtons: true,
                          onSubmit: (Object? value) {
                            if (value is PickerDateRange) {
                              setState(() {
                                begin = value.startDate!;
                                end = (value.endDate ?? value.startDate)!;
                                range = false;
                              });
                              cloudCtx.changeDateDiff(begin, end);
                            }
                          },
                          onCancel: () => setState(() => range = false),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> serChg(
      String service, CloudCtx cloudCtx, String filter) {
    if (filter == "Year") {
      cloudCtx.changeYear(year);
    } else if (filter == "Date Range") {
      cloudCtx.changeDateDiff(begin, end);
    } else if (filter == "Months") {
      cloudCtx.changeMonth(month, year);
    }
    switch (service) {
      case "All Services":
        return cloudCtx.sAll;
      case "Sundays":
        return cloudCtx.sSun;
      case "Revivals":
        return cloudCtx.sRev;
      case "Bibles":
        return cloudCtx.sBib;
      case "Others":
        return cloudCtx.sOth;
      default:
        return cloudCtx.sAll;
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

  List<PopupMenuItem<String>> _filter(
      BuildContext context, TextStyling textStyling) {
    List<PopupMenuItem<String>> popupMenuItems = [];
    for (String filter in _filters) {
      popupMenuItems.add(PopupMenuItem(
        value: filter,
        child: Text(
          filter,
          style: textStyling.medium16,
        ),
      ));
    }

    return popupMenuItems;
  }

  List<PopupMenuItem<String>> _year(
      BuildContext context, TextStyling textStyling) {
    List<PopupMenuItem<String>> popupMenuItems = [];
    for (Years year in cloudCtx.years) {
      popupMenuItems.add(PopupMenuItem(
        value: year.year!,
        child: Text(
          year.year!,
          style: textStyling.medium16,
        ),
      ));
    }

    return popupMenuItems;
  }

  List<PopupMenuItem<String>> _month(
      BuildContext context, TextStyling textStyling) {
    List<PopupMenuItem<String>> popupMenuItems = [];
    for (String month in cloudCtx.months) {
      popupMenuItems.add(PopupMenuItem(
        value: month,
        child: Text(
          month,
          style: textStyling.medium16,
        ),
      ));
    }

    return popupMenuItems;
  }
}
