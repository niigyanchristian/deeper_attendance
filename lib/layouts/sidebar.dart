import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/auth.dart';
import '../controllers/blocs.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../routes/divisional.dart';
import '../routes/group.dart';
import '../routes/location.dart';
import '../routes/national.dart';
import '../routes/regional.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';
import 'menu_item.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  late AnimationController _animationController;
  final _animationDuration = const Duration(milliseconds: 400);
  int selected = 1;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthCtx authCtx = Get.find<AuthCtx>();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppThemes themes = Provider.of<AppThemes>(context);
    MenuState menuState = Provider.of<MenuState>(context);
    MenuBloc menuBloc = Provider.of<MenuBloc>(context);
    PageBloc pageBloc = Provider.of<PageBloc>(context);
    ThemeVar theme = themes.appTheme;
    TextStyling textStyling = themes.textStyling;
    Local local = Provider.of<Local>(context);
    String profile = local.user("user")!.profile!;

    return Stack(
      children: [
        menuState.state
            ? GestureDetector(
                onTap: () {
                  onIconPressed();
                  menuState.add(Bool.deactivate);
                },
                child: Container(
                  height: height,
                  width: width,
                  color: theme.primary!.withOpacity(0.01),
                ),
              )
            : Container(),
        AnimatedPositioned(
          duration: _animationDuration,
          curve: Curves.decelerate,
          top: 0,
          bottom: 0,
          left: menuState.state ? 0 : -245,
          child: SizedBox(
            width: 280,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: height,
                    padding: const EdgeInsets.only(left: 10, right: 14),
                    decoration: BoxDecoration(
                      color: theme.card,
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary!.withOpacity(0.05),
                          offset: const Offset(5.0, 0.0),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 45,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage("assets/images/deeper.png"),
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Deeper Life\nBible Church",
                                style: textStyling.bold22,
                              ),
                            ],
                          ),
                          Divider(
                            height: 40,
                            thickness: 0.5,
                            color: muted,
                            indent: 20,
                            endIndent: 20,
                          ),
                          routes(profile, pageBloc, menuBloc, menuState,
                              _animationController),
                          IconMenuItem(
                            title: "Logout",
                            onTap: () => authCtx.signOut(local, menuBloc,
                                menuState, pageBloc, _animationController),
                            isSelected: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 1),
                  child: GestureDetector(
                    onTap: () {
                      menuState.state
                          ? menuState.add(Bool.deactivate)
                          : menuState.add(Bool.activate);
                      onIconPressed();
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        width: 35,
                        height: 100,
                        color: theme.card,
                        alignment: Alignment.centerLeft,
                        child: AnimatedIcon(
                          progress: _animationController.view,
                          icon: AnimatedIcons.menu_close,
                          color: theme.primary,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget routes(String profile, PageBloc pageBloc, MenuBloc menuBloc,
      MenuState menuState, AnimationController animationController) {
    List<SidebarItem> routes =
        route(profile, pageBloc, menuBloc, menuState, animationController);
    List<Widget> lists = [];

    for (SidebarItem route in routes) {
      lists.add(
        IconMenuItem(
          title: route.name,
          onTap: route.onTap,
          isSelected: menuBloc.state == route.id,
        ),
      );
    }

    return Column(
      children: lists,
    );
  }

  List<SidebarItem> route(String profile, PageBloc pageBloc, MenuBloc menuBloc,
      MenuState menuState, AnimationController animationController) {
    switch (profile) {
      case "national":
        return national(pageBloc, menuBloc, menuState, animationController);
      case "region":
        return regional(pageBloc, menuBloc, menuState, animationController);
      case "division":
        return divisional(pageBloc, menuBloc, menuState, animationController);
      case "group":
        return group(pageBloc, menuBloc, menuState, animationController);
      case "location":
        return location(pageBloc, menuBloc, menuState, animationController);
      case "reviewer":
        return location(pageBloc, menuBloc, menuState, animationController);
      default:
        return national(pageBloc, menuBloc, menuState, animationController);
    }
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = black;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class SidebarItem {
  final int id;
  final String? name;
  final void Function()? onTap;

  SidebarItem({required this.id, this.name, this.onTap});
}
