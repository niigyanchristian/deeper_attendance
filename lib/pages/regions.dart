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

class Regions extends StatefulWidget with PageState {
  const Regions({Key? key}) : super(key: key);

  @override
  State<Regions> createState() => _RegionsState();
}

class _RegionsState extends State<Regions> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  CloudCtx cloudCtx = Get.find<CloudCtx>();

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
    TextStyling textStyling = themes.textStyling;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: GetX(
            init: cloudCtx,
            builder: (CloudCtx cloudCtx) {
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
                            Text("Regions", style: textStyling.bold24),
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
                                        "${cloudCtx.regions.length} Regions",
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
                            regions(themes, cloudCtx, textStyling),
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

  Widget regions(AppThemes themes, CloudCtx cloudCtx, TextStyling textStyling) {
    List<Widget> list = [];

    for (RegionModel region in cloudCtx.regions) {
      list.add(
        GestureDetector(
          onTap: () {
            cloudCtx.addSelected(SelectedSection(
                area: region.name,
                areaID: region.regionID,
                type: "region",
                isSection: true));
            Get.to(() => const Selected());
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
                  "${cloudCtx.divisions.where((ele) => ele.regionID == region.regionID).length}",
                  style: textStyling.light25!.copyWith(fontSize: 40),
                ),
                Text(
                  cloudCtx.divisions
                              .where((ele) => ele.regionID == region.regionID)
                              .length >
                          1
                      ? "divisions"
                      : "division",
                  style: textStyling.medium14,
                ),
                const SizedBox(height: 24),
                Text(
                  region.name!,
                  style: textStyling.bold17,
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
