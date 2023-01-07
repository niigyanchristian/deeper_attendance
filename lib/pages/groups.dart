import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/blocs.dart';
import '../controllers/cloud.dart';
import '../controllers/theme.dart';
import '../models/app.dart';
import '../models/cloud.dart';
import '../pages/selected.dart';
import '../styles/texts.dart';

class Groups extends StatefulWidget with PageState {
  const Groups({Key? key}) : super(key: key);

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  CloudCtx cloudCtx = Get.find<CloudCtx>();

  @override
  void initState() {
    super.initState();
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
    TextStyling textStyling = themes.textStyling;
    /* List<RegionModel> reg = Provider.of<List<RegionModel>>(context);*/

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: GetX(
            init: cloudCtx,
            builder: (CloudCtx cloudCtx) {
              List<GroupModel> grp = cloudCtx.admin.profile == "national"
                  ? cloudCtx.groups
                  : cloudCtx.groups
                      .where((ele) =>
                          cloudCtx.wr(ele, cloudCtx.admin.profile!) ==
                          cloudCtx.admin.areaID)
                      .toList();

              return SizedBox(
                width: width,
                height: height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        padding: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Groups", style: textStyling.bold24),
                            Row(
                              children: [
                                const Spacer(),
                                Container(
                                  decoration: themes.foreground,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  margin:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${grp.length} Groups",
                                        style: textStyling.bold14,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width - 20,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: themes.foreground.copyWith(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.zero, top: Radius.circular(20))),
                        child: Column(
                          children: [
                            groups(themes, cloudCtx, textStyling, grp),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget groups(AppThemes themes, CloudCtx cloudCtx, TextStyling textStyling,
      List<GroupModel> grp) {
    List<Widget> list = [];

    for (GroupModel group in grp) {
      list.add(
        GestureDetector(
          onTap: () {
            cloudCtx.addSelected(SelectedSection(
                area: group.name,
                areaID: group.groupID,
                type: "group",
                isSection: true));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Selected(),
                ));
          },
          child: Container(
            height: 198,
            width: 160,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: themes.bordersSm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${cloudCtx.locations.where((ele) => ele.groupID == group.groupID).length}",
                  style: textStyling.light25!.copyWith(fontSize: 40),
                ),
                Text(
                  cloudCtx.locations
                              .where((ele) => ele.groupID == group.groupID)
                              .length >
                          1
                      ? "locations"
                      : "location",
                  style: textStyling.medium14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  group.name!,
                  style: textStyling.bold17,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  "${group.division} Division",
                  style: textStyling.medium14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  "${group.region} Region",
                  style: textStyling.medium14,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 15,
      runSpacing: 15,
      children: list,
    );
  }
}
