import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/blocs.dart';
import '../controllers/cloud.dart';
import '../layouts/sidebar.dart';
import 'exit.dart';

class AppLayer extends StatefulWidget {
  const AppLayer({Key? key}) : super(key: key);

  @override
  State<AppLayer> createState() => _AppLayerState();
}

class _AppLayerState extends State<AppLayer> {
  String? page;
  CloudCtx cloudCtx = Get.put(CloudCtx());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ExitModal exitModal = Provider.of<ExitModal>(context);
    MenuState menuState = Provider.of<MenuState>(context);
    MenuBloc menuBloc = Provider.of<MenuBloc>(context);
    PageBloc pageBloc = Provider.of<PageBloc>(context);

    return WillPopScope(
      onWillPop: () => _exit(exitModal, menuBloc, pageBloc, menuState),
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: BlocBuilder<PageBloc, PageState>(
                builder: (BuildContext context, PageState pageState) {
                  return pageState as Widget;
                },
              ),
            ),
            const SideBar(),
            const Exit(),
          ],
        ),
      ),
    );
  }

  _exit(ExitModal exitModal, MenuBloc menuBloc, PageBloc pageBloc,
      MenuState menuState) {
    if (menuState.state) {
      menuState.add(Bool.deactivate);
    } else if (menuBloc.state != 0) {
      menuBloc.add(PageVal.dashboard);
      pageBloc.add(PageVal.dashboard);
    } else if (exitModal.state) {
      exitModal.add(Bool.deactivate);
    } else {
      exitModal.add(Bool.activate);
    }
  }
}
