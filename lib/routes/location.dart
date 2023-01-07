import 'package:flutter/material.dart';

import '../controllers/blocs.dart';
import '../layouts/sidebar.dart';

List<SidebarItem> location(PageBloc pageBloc, MenuBloc menuBloc,
        MenuState menuState, AnimationController animationController) =>
    [
      SidebarItem(
        name: "Dashboard",
        onTap: () {
          pageBloc.add(PageVal.dashboard);
          menuBloc.add(PageVal.dashboard);
          menuState.add(Bool.deactivate);
          final animationStatus = animationController.status;
          final isAnimationCompleted =
              animationStatus == AnimationStatus.completed;

          if (isAnimationCompleted) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        },
        id: 0,
      ),
      SidebarItem(
        name: "Profile",
        onTap: () {
          pageBloc.add(PageVal.profile);
          menuBloc.add(PageVal.profile);
          menuState.add(Bool.deactivate);
          final animationStatus = animationController.status;
          final isAnimationCompleted =
              animationStatus == AnimationStatus.completed;

          if (isAnimationCompleted) {
            animationController.reverse();
          } else {
            animationController.forward();
          }
        },
        id: 5,
      ),
    ];
