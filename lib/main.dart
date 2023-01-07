import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import './bindings/auth.dart';
import './controllers/blocs.dart';
import './controllers/theme.dart';
import './database/local.dart';
import './layouts/layers.dart';
import 'models/local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter<ThemeModel>(ThemeModelAdapter());
  Hive.registerAdapter<IsUser>(IsUserAdapter());
  Hive.registerAdapter<CurrentUser>(CurrentUserAdapter());
  final Box<CurrentUser> current = await Hive.openBox<CurrentUser>("current");
  final Box<ThemeModel> themeBox = await Hive.openBox<ThemeModel>("theme");
  final Box<IsUser> userBox = await Hive.openBox<IsUser>("user");
  if (themeBox.values.isEmpty) {
    themeBox.put("isDark", ThemeModel(isDark: false));
  }
  if (userBox.values.isEmpty) {
    userBox.put("user", IsUser(user: ""));
    userBox.put("year", IsUser(year: DateFormat("y").format(DateTime.now())));
  }
  if (userBox.get("started") == null) {
    userBox.put("started", IsUser(started: false));
  }
  if (current.values.isEmpty) {
    current.put(
      "user",
      CurrentUser(
        uid: "",
        email: "",
        username: "",
        profile: "",
        position: "",
        areaID: "",
        area: "",
        others: [],
      ),
    );
  }
  userBox.put("available", IsUser(available: false));
  if (userBox.get("biometric") == null) {
    userBox.put("biometric", IsUser(biometric: false));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemes>(
          create: (BuildContext context) => AppThemes(box: themeBox),
        ),
        ChangeNotifierProvider<Local>(
          create: (BuildContext context) =>
              Local(userBox: userBox, cUserBox: current),
        ),
        BlocProvider<ExitModal>(
          create: (BuildContext context) => ExitModal(),
        ),
        BlocProvider<MenuState>(
          create: (BuildContext context) => MenuState(),
        ),
        BlocProvider<MenuBloc>(
          create: (BuildContext context) => MenuBloc(),
        ),
        BlocProvider<PageBloc>(
          create: (BuildContext context) => PageBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);

    return GetMaterialApp(
      title: 'DLBC Beta',
      debugShowCheckedModeBanner: false,
      theme: themes.lightTheme.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      themeMode: themes.themeMode,
      darkTheme: themes.darkTheme.copyWith(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialBinding: AuthBinding(),
      home: const Home(),
    );
  }
}
