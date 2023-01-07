import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/auth.dart';
import '../controllers/cloud.dart';
import '../controllers/theme.dart';
import '../database/local.dart';
import '../layouts/app.dart';
import '../pages/welcome.dart';
import '../styles/colours.dart';

class Layers extends StatefulWidget {
  const Layers({Key? key}) : super(key: key);

  @override
  State<Layers> createState() => _LayersState();
}

class _LayersState extends State<Layers> {
  @override
  Widget build(BuildContext context) {
    Get.put<CloudCtx>(CloudCtx());
    Local local = Provider.of<Local>(context);
    bool isUser = local.getUser("available")!.available!;

    return isUser ? const AppLayer() : const Welcome();
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    AuthCtx authCtx = Get.find<AuthCtx>();
    Local local = Provider.of<Local>(context);
    AppThemes themes = Provider.of<AppThemes>(context);
    ThemeVar theme = themes.appTheme;

    if (local.getUser("started")!.started!) {
      return const Layers();
    } else {
      authCtx.signInAnon(local);
      return Scaffold(
        body: Center(
          child: SpinKitPulse(
            color: theme.primary,
            size: 40,
          ),
        ),
      );
    }
  }
}
