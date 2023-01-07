import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../controllers/theme.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class ProfileItem extends StatelessWidget {
  final PageController? pageController;
  final int? current;
  final IconData? icon;
  final String? image;
  final String? title;
  final String? sub;
  final bool? img;
  final int? page;

  const ProfileItem(
      {Key? key,
      this.pageController,
      this.current,
      this.icon,
      this.image,
      this.title,
      this.sub,
      this.img,
      this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;

    return AnimatedBuilder(
        animation: pageController!,
        builder: (context, child) {
          double value = 1;
          if (pageController!.position.haveDimensions) {
            value = pageController!.page! - current!;
            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
          } else {
            value = double.parse("$page") - current!;
            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
          }

          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  height: 0.9 * 320 * value,
                  width: 0.9 * screenWidth,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.2),
                        offset: const Offset(0.0, 10.0),
                        blurRadius: 25,
                        spreadRadius: -15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      img!
                          ? Image(
                              image: AssetImage(
                                image!,
                              ),
                              height: 100 * value,
                              color: secondary,
                            )
                          : FaIcon(
                              icon,
                              size: 70 * value,
                              color: secondary,
                            ),
                      Text(
                        title!,
                        style: textStyling.medium22!.copyWith(
                          fontSize: 22 * value,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          sub!,
                          style: textStyling.regularMuted13!
                              .copyWith(color: danger),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class RegionItem extends StatelessWidget {
  final PageController? pageController;
  final int? current;
  final String? image;
  final String? region;

  const RegionItem({
    Key? key,
    this.pageController,
    this.current,
    this.image,
    this.region,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;

    return AnimatedBuilder(
        animation: pageController!,
        builder: (context, child) {
          double value = 1;
          if (pageController!.position.haveDimensions) {
            value = pageController!.page! - current!;
            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
          } else {
            value = 0.0 - current!;
            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
          }
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  height: 0.9 * 250 * value,
                  width: 0.9 * screenWidth,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: black.withOpacity(0.2),
                        offset: const Offset(0.0, 10.0),
                        blurRadius: 25,
                        spreadRadius: -15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Image(
                          image: AssetImage(
                            "assets/images/$image",
                          ),
                          height: 100 * value,
                          color: secondary,
                        ),
                      ),
                      Text(
                        region!,
                        style: textStyling.medium22!.copyWith(
                          fontSize: 22 * value,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class PageViewItems extends StatelessWidget {
  final PageController? pageController;
  final int? current;
  final String? name;

  const PageViewItems({
    Key? key,
    this.pageController,
    this.current,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;
    TextStyling textStyling = themes.textStyling;

    return AnimatedBuilder(
        animation: pageController!,
        builder: (context, child) {
          double value = 1;
          if (pageController!.position.haveDimensions) {
            value = pageController!.page! - current!;
            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
          } else {
            value = 0.0 - current!;
            value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
          }
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  height: 0.9 * 250 * value,
                  width: 0.9 * screenWidth,
                  decoration: themes.foreground,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        bottom: 5,
                        left: 3,
                        child: Text(
                          name!,
                          style: textStyling.medium22!.copyWith(
                            fontSize: 55 * value,
                            color: theme.primary!.withOpacity(0.1),
                            height: 0.7,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 15,
                        child: Text(
                          name!,
                          style: textStyling.bold22!.copyWith(
                            fontSize: 22 * value,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}

class ValueBox extends StatelessWidget {
  final String title;
  final String value;

  const ValueBox({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;

    return Container(
      height: 140,
      width: 200,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(right: 20),
      decoration: themes.pops,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: textStyling.regularMuted16,
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              value,
              style: textStyling.bold24!.copyWith(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class OfferBox extends StatelessWidget {
  final String title;
  final String value;

  const OfferBox({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;

    return Container(
      height: 140,
      width: 200,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(right: 20),
      decoration: themes.pops,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: textStyling.regularMuted16,
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              "¢${value.toStringFix(2)}",
              style: textStyling.bold24!.copyWith(fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class ValueBoxGender extends StatelessWidget {
  final String title;
  final String valueMale;
  final String valueFemale;
  final String total;

  const ValueBoxGender(
      {Key? key,
      required this.title,
      required this.valueMale,
      required this.valueFemale,
      required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;

    return Container(
      height: 140,
      width: 200,
      padding: const EdgeInsets.only(right: 20, top: 15, left: 20, bottom: 7),
      margin: const EdgeInsets.only(right: 20),
      decoration: themes.pops,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textStyling.regularMuted14,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Males",
                        style: textStyling.regular14,
                      ),
                      Text(
                        valueMale,
                        style: textStyling.bold22,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Females",
                        style: textStyling.regular14,
                      ),
                      Text(
                        valueFemale,
                        style: textStyling.bold22,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Text(
                total,
                style: textStyling.bold24!.copyWith(fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ValueBoxAll extends StatelessWidget {
  final String title;
  final String value;

  const ValueBoxAll({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 140,
      width: width <= 360 ? 160 : 170,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      decoration: themes.pops,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: textStyling.regularMuted15,
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              value,
              style: textStyling.bold20,
            ),
          ),
        ],
      ),
    );
  }
}

class OfferBoxAll extends StatelessWidget {
  final String title;
  final String value;

  const OfferBoxAll({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 140,
      width: width <= 360 ? 160 : 170,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      decoration: themes.pops,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: textStyling.regularMuted15,
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Text(
              "¢${value.toStringFix(2)}",
              style: textStyling.bold20,
            ),
          ),
        ],
      ),
    );
  }
}

class ValueBoxGenderAll extends StatelessWidget {
  final String title;
  final String valueMale;
  final String valueFemale;
  final String total;

  const ValueBoxGenderAll(
      {Key? key,
      required this.title,
      required this.valueMale,
      required this.valueFemale,
      required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyling = themes.textStyling;
    double width = MediaQuery.of(context).size.width;

    return Container(
      height: 140,
      width: width <= 360 ? 160 : 170,
      padding: const EdgeInsets.only(right: 20, top: 15, left: 20, bottom: 7),
      margin: const EdgeInsets.symmetric(horizontal: 7.5),
      decoration: themes.pops,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: textStyling.regularMuted15,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Males",
                        style: textStyling.regular13,
                      ),
                      Text(
                        valueMale,
                        style: textStyling.bold15,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Females",
                        style: textStyling.regular13,
                      ),
                      Text(
                        valueFemale,
                        style: textStyling.bold15,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Text(
                total,
                style: textStyling.bold20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
