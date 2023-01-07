import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/local.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class AppThemes extends ChangeNotifier {
  final Box<ThemeModel>? box;
  late ThemeMode themeMode;

  AppThemes({this.box}) {
    themeMode = box!.get("theme") != null
        ? themeCheck(box!.get("theme")!.theme!)
        : themeCheck("system");
  }

  bool get isDark {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      changeNav(brightness == Brightness.dark);
      return brightness == Brightness.dark;
    } else {
      changeNav(themeMode == ThemeMode.dark);
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  changeNav(bool isDark) {
    if (isDark) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color.fromRGBO(26, 26, 26, 1),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color.fromRGBO(244, 245, 249, 1),
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    }
  }

  bool? get theme => isDark;

  Color get color => isDark ? card : Colors.white;

  changeTheme(String theme) {
    box!.put("theme", ThemeModel(theme: theme));
    themeMode = themeCheck(theme);
    notifyListeners();
  }

  ThemeMode themeCheck(String theme) {
    switch (theme) {
      case "system":
        return ThemeMode.system;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.light;
    }
  }

  TextStyling get textStyle {
    return TextStyling(
      boldWhite: const TextStyle(
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      boldMuted: const TextStyle(
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      bold: TextStyle(
        color: appTheme.primary,
        fontWeight: FontWeight.w700,
        height: 1.1,
      ),
      mediumMuted: const TextStyle(
        fontWeight: FontWeight.w500,
        height: 1.1,
      ),
      medium: TextStyle(
        color: appTheme.primary,
        fontWeight: FontWeight.w500,
        height: 1.1,
      ),
      regular: TextStyle(
        color: appTheme.primary,
        fontWeight: FontWeight.w400,
        height: 1.1,
      ),
      light: TextStyle(
        color: appTheme.primary,
        fontWeight: FontWeight.w300,
        height: 1.1,
      ),
      regularMuted: const TextStyle(
        fontWeight: FontWeight.w400,
        height: 1.1,
      ),
      lightMuted: const TextStyle(
        fontWeight: FontWeight.w300,
        height: 1.1,
      ),
    );
  }

  TextStyling get textStyling {
    return TextStyling(
      boldWhite25: textStyle.boldWhite!.copyWith(fontSize: 25, color: white),
      boldWhite24: textStyle.boldWhite!.copyWith(fontSize: 24, color: white),
      boldWhite23: textStyle.boldWhite!.copyWith(fontSize: 23, color: white),
      boldWhite22: textStyle.boldWhite!.copyWith(fontSize: 22, color: white),
      boldWhite21: textStyle.boldWhite!.copyWith(fontSize: 21, color: white),
      boldWhite20: textStyle.boldWhite!.copyWith(fontSize: 20, color: white),
      boldWhite19: textStyle.boldWhite!.copyWith(fontSize: 19, color: white),
      boldWhite18: textStyle.boldWhite!.copyWith(fontSize: 18, color: white),
      boldWhite17: textStyle.boldWhite!.copyWith(fontSize: 17, color: white),
      boldWhite16: textStyle.boldWhite!.copyWith(fontSize: 16, color: white),
      boldWhite15: textStyle.boldWhite!.copyWith(fontSize: 15, color: white),
      boldWhite14: textStyle.boldWhite!.copyWith(fontSize: 14, color: white),
      boldWhite13: textStyle.boldWhite!.copyWith(fontSize: 13, color: white),
      boldWhite12: textStyle.boldWhite!.copyWith(fontSize: 12, color: white),
      boldWhite11: textStyle.boldWhite!.copyWith(fontSize: 11, color: white),
      boldWhite10: textStyle.boldWhite!.copyWith(fontSize: 10, color: white),
      boldMuted25: textStyle.boldMuted!.copyWith(fontSize: 25, color: muted),
      boldMuted24: textStyle.boldMuted!.copyWith(fontSize: 24, color: muted),
      boldMuted23: textStyle.boldMuted!.copyWith(fontSize: 23, color: muted),
      boldMuted22: textStyle.boldMuted!.copyWith(fontSize: 22, color: muted),
      boldMuted21: textStyle.boldMuted!.copyWith(fontSize: 21, color: muted),
      boldMuted20: textStyle.boldMuted!.copyWith(fontSize: 20, color: muted),
      boldMuted19: textStyle.boldMuted!.copyWith(fontSize: 19, color: muted),
      boldMuted18: textStyle.boldMuted!.copyWith(fontSize: 18, color: muted),
      boldMuted17: textStyle.boldMuted!.copyWith(fontSize: 17, color: muted),
      boldMuted16: textStyle.boldMuted!.copyWith(fontSize: 16, color: muted),
      boldMuted15: textStyle.boldMuted!.copyWith(fontSize: 15, color: muted),
      boldMuted14: textStyle.boldMuted!.copyWith(fontSize: 14, color: muted),
      boldMuted13: textStyle.boldMuted!.copyWith(fontSize: 13, color: muted),
      boldMuted12: textStyle.boldMuted!.copyWith(fontSize: 12, color: muted),
      boldMuted11: textStyle.boldMuted!.copyWith(fontSize: 11, color: muted),
      boldMuted10: textStyle.boldMuted!.copyWith(fontSize: 10, color: muted),
      bold25: textStyle.bold!.copyWith(fontSize: 25),
      bold24: textStyle.bold!.copyWith(fontSize: 24),
      bold23: textStyle.bold!.copyWith(fontSize: 23),
      bold22: textStyle.bold!.copyWith(fontSize: 22),
      bold21: textStyle.bold!.copyWith(fontSize: 21),
      bold20: textStyle.bold!.copyWith(fontSize: 20),
      bold19: textStyle.bold!.copyWith(fontSize: 19),
      bold18: textStyle.bold!.copyWith(fontSize: 18),
      bold17: textStyle.bold!.copyWith(fontSize: 17),
      bold16: textStyle.bold!.copyWith(fontSize: 16),
      bold15: textStyle.bold!.copyWith(fontSize: 15),
      bold14: textStyle.bold!.copyWith(fontSize: 14),
      bold13: textStyle.bold!.copyWith(fontSize: 13),
      bold12: textStyle.bold!.copyWith(fontSize: 12),
      bold11: textStyle.bold!.copyWith(fontSize: 11),
      bold10: textStyle.bold!.copyWith(fontSize: 10),
      mediumMuted25:
      textStyle.mediumMuted!.copyWith(fontSize: 25, color: muted),
      mediumMuted24:
      textStyle.mediumMuted!.copyWith(fontSize: 24, color: muted),
      mediumMuted23:
      textStyle.mediumMuted!.copyWith(fontSize: 23, color: muted),
      mediumMuted22:
      textStyle.mediumMuted!.copyWith(fontSize: 22, color: muted),
      mediumMuted21:
      textStyle.mediumMuted!.copyWith(fontSize: 21, color: muted),
      mediumMuted20:
      textStyle.mediumMuted!.copyWith(fontSize: 20, color: muted),
      mediumMuted19:
      textStyle.mediumMuted!.copyWith(fontSize: 19, color: muted),
      mediumMuted18:
      textStyle.mediumMuted!.copyWith(fontSize: 18, color: muted),
      mediumMuted17:
      textStyle.mediumMuted!.copyWith(fontSize: 17, color: muted),
      mediumMuted16:
      textStyle.mediumMuted!.copyWith(fontSize: 16, color: muted),
      mediumMuted15:
      textStyle.mediumMuted!.copyWith(fontSize: 15, color: muted),
      mediumMuted14:
      textStyle.mediumMuted!.copyWith(fontSize: 14, color: muted),
      mediumMuted13:
      textStyle.mediumMuted!.copyWith(fontSize: 13, color: muted),
      mediumMuted12:
      textStyle.mediumMuted!.copyWith(fontSize: 12, color: muted),
      mediumMuted11:
      textStyle.mediumMuted!.copyWith(fontSize: 11, color: muted),
      mediumMuted10:
      textStyle.mediumMuted!.copyWith(fontSize: 10, color: muted),
      medium25: textStyle.medium!.copyWith(fontSize: 25),
      medium24: textStyle.medium!.copyWith(fontSize: 24),
      medium23: textStyle.medium!.copyWith(fontSize: 23),
      medium22: textStyle.medium!.copyWith(fontSize: 22),
      medium21: textStyle.medium!.copyWith(fontSize: 21),
      medium20: textStyle.medium!.copyWith(fontSize: 20),
      medium19: textStyle.medium!.copyWith(fontSize: 19),
      medium18: textStyle.medium!.copyWith(fontSize: 18),
      medium17: textStyle.medium!.copyWith(fontSize: 17),
      medium16: textStyle.medium!.copyWith(fontSize: 16),
      medium15: textStyle.medium!.copyWith(fontSize: 15),
      medium14: textStyle.medium!.copyWith(fontSize: 14),
      medium13: textStyle.medium!.copyWith(fontSize: 13),
      medium12: textStyle.medium!.copyWith(fontSize: 12),
      medium11: textStyle.medium!.copyWith(fontSize: 11),
      medium10: textStyle.medium!.copyWith(fontSize: 10),
      regularMuted25:
      textStyle.regularMuted!.copyWith(fontSize: 25, color: muted),
      regularMuted24:
      textStyle.regularMuted!.copyWith(fontSize: 24, color: muted),
      regularMuted23:
      textStyle.regularMuted!.copyWith(fontSize: 23, color: muted),
      regularMuted22:
      textStyle.regularMuted!.copyWith(fontSize: 22, color: muted),
      regularMuted21:
      textStyle.regularMuted!.copyWith(fontSize: 21, color: muted),
      regularMuted20:
      textStyle.regularMuted!.copyWith(fontSize: 20, color: muted),
      regularMuted19:
      textStyle.regularMuted!.copyWith(fontSize: 19, color: muted),
      regularMuted18:
      textStyle.regularMuted!.copyWith(fontSize: 18, color: muted),
      regularMuted17:
      textStyle.regularMuted!.copyWith(fontSize: 17, color: muted),
      regularMuted16:
      textStyle.regularMuted!.copyWith(fontSize: 16, color: muted),
      regularMuted15:
      textStyle.regularMuted!.copyWith(fontSize: 15, color: muted),
      regularMuted14:
      textStyle.regularMuted!.copyWith(fontSize: 14, color: muted),
      regularMuted13:
      textStyle.regularMuted!.copyWith(fontSize: 13, color: muted),
      regularMuted12:
      textStyle.regularMuted!.copyWith(fontSize: 12, color: muted),
      regularMuted11:
      textStyle.regularMuted!.copyWith(fontSize: 11, color: muted),
      regularMuted10:
      textStyle.regularMuted!.copyWith(fontSize: 10, color: muted),
      regular25: textStyle.regular!.copyWith(fontSize: 25),
      regular24: textStyle.regular!.copyWith(fontSize: 24),
      regular23: textStyle.regular!.copyWith(fontSize: 23),
      regular22: textStyle.regular!.copyWith(fontSize: 22),
      regular21: textStyle.regular!.copyWith(fontSize: 21),
      regular20: textStyle.regular!.copyWith(fontSize: 20),
      regular19: textStyle.regular!.copyWith(fontSize: 19),
      regular18: textStyle.regular!.copyWith(fontSize: 18),
      regular17: textStyle.regular!.copyWith(fontSize: 17),
      regular16: textStyle.regular!.copyWith(fontSize: 16),
      regular15: textStyle.regular!.copyWith(fontSize: 15),
      regular14: textStyle.regular!.copyWith(fontSize: 14),
      regular13: textStyle.regular!.copyWith(fontSize: 13),
      regular12: textStyle.regular!.copyWith(fontSize: 12),
      regular11: textStyle.regular!.copyWith(fontSize: 11),
      regular10: textStyle.regular!.copyWith(fontSize: 10),
      lightMuted25: textStyle.lightMuted!.copyWith(fontSize: 25),
      lightMuted24: textStyle.lightMuted!.copyWith(fontSize: 24),
      lightMuted23: textStyle.lightMuted!.copyWith(fontSize: 23),
      lightMuted22: textStyle.lightMuted!.copyWith(fontSize: 22),
      lightMuted21: textStyle.lightMuted!.copyWith(fontSize: 21),
      lightMuted20: textStyle.lightMuted!.copyWith(fontSize: 20),
      lightMuted19: textStyle.lightMuted!.copyWith(fontSize: 19),
      lightMuted18: textStyle.lightMuted!.copyWith(fontSize: 18),
      lightMuted17: textStyle.lightMuted!.copyWith(fontSize: 17),
      lightMuted16: textStyle.lightMuted!.copyWith(fontSize: 16),
      lightMuted15: textStyle.lightMuted!.copyWith(fontSize: 15),
      lightMuted14: textStyle.lightMuted!.copyWith(fontSize: 14),
      lightMuted13: textStyle.lightMuted!.copyWith(fontSize: 13),
      lightMuted12: textStyle.lightMuted!.copyWith(fontSize: 12),
      lightMuted11: textStyle.lightMuted!.copyWith(fontSize: 11),
      lightMuted10: textStyle.lightMuted!.copyWith(fontSize: 10),
      light25: textStyle.light!.copyWith(fontSize: 25),
      light24: textStyle.light!.copyWith(fontSize: 24),
      light23: textStyle.light!.copyWith(fontSize: 23),
      light22: textStyle.light!.copyWith(fontSize: 22),
      light21: textStyle.light!.copyWith(fontSize: 21),
      light20: textStyle.light!.copyWith(fontSize: 20),
      light19: textStyle.light!.copyWith(fontSize: 19),
      light18: textStyle.light!.copyWith(fontSize: 18),
      light17: textStyle.light!.copyWith(fontSize: 17),
      light16: textStyle.light!.copyWith(fontSize: 16),
      light15: textStyle.light!.copyWith(fontSize: 15),
      light14: textStyle.light!.copyWith(fontSize: 14),
      light13: textStyle.light!.copyWith(fontSize: 13),
      light12: textStyle.light!.copyWith(fontSize: 12),
      light11: textStyle.light!.copyWith(fontSize: 11),
      light10: textStyle.light!.copyWith(fontSize: 10),
    );
  }

  ThemeVar get appTheme {
    return ThemeVar(
      background: isDark ? backgroundDark : backgroundLight,
      primary: isDark ? white : primary,
      card: isDark ? card : white,
      secondary: isDark ? muted : secondary,
      white: isDark ? primary : white,
    );
  }

  ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: backgroundDark,
    primarySwatch: Colors.grey,
    /*primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),*/
  );

  ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundLight,
    primarySwatch: Colors.grey,
    /*primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),*/
  );

  BoxDecoration get foreground {
    return BoxDecoration(
      color: appTheme.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(isDark ? 0.7 : 0.15),
          offset: const Offset(0.0, 6.0),
          blurRadius: isDark ? 17 : 13,
          spreadRadius: -5,
        ),
      ],
    );
  }

  BoxDecoration get nav {
    return BoxDecoration(
      color: isDark ? white : darkCard,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(isDark ? 0.7 : 0.15),
          offset: const Offset(0.0, 6.0),
          blurRadius: isDark ? 17 : 13,
          spreadRadius: -5,
        ),
      ],
    );
  }

  BoxDecoration get button {
    return BoxDecoration(
      color: appTheme.primary,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(isDark ? 0.7 : 0.15),
          offset: const Offset(0.0, 6.0),
          blurRadius: isDark ? 17 : 13,
          spreadRadius: -5,
        ),
      ],
    );
  }

  BoxDecoration get capsule {
    return BoxDecoration(
      color: appTheme.card,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(isDark ? 0.6 : 0.15),
          offset: const Offset(0.0, 4.0),
          blurRadius: isDark ? 10 : 8,
        ),
      ],
    );
  }

  BoxDecoration get borders {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: appTheme.primary!,
        width: 1.5,
      ),
    );
  }

  BoxDecoration get bordersSm {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        color: appTheme.primary!,
        width: 1.5,
      ),
    );
  }

  BoxDecoration get smallBox {
    return BoxDecoration(
      color: appTheme.card,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(isDark ? 0.3 : 0.1),
          offset: const Offset(0.0, 0.0),
          blurRadius: 15,
        ),
      ],
    );
  }

  BoxDecoration get icon {
    return BoxDecoration(
      color: appTheme.card,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.3),
          offset: const Offset(0.0, 4.0),
          blurRadius: 12,
        ),
      ],
    );
  }

  BoxDecoration get pops {
    return BoxDecoration(
      color: appTheme.card,
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(isDark ? 0.7 : 0.15),
          offset: const Offset(0.0, 6.0),
          blurRadius: isDark ? 17 : 13,
          spreadRadius: -5,
        ),
      ],
    );
  }
}

extension DateTimeExtension on DateTime {
  String formatDateTimeLine() {
    DateFormat dateFormat = DateFormat('EEE, d MMM, y');
    DateFormat timeFormat = DateFormat('h:mm a');

    return hour != 0
        ? "${dateFormat.format(this)}\n${timeFormat.format(this)}"
        : "${dateFormat.format(this)}\n";
  }

  String formatDate() {
    final dateFormat = DateFormat('EEEE, d MMMM, y');
    return dateFormat.format(this);
  }

  String formatDateTime() {
    DateFormat dateFormat = DateFormat('EE, d MMM, y - h:mm a');
    return dateFormat.format(this);
  }

  String formatTime() {
    DateFormat timeFormat = DateFormat('h:mm a');
    return timeFormat.format(this);
  }

  String formatDay() {
    DateFormat dateFormat = DateFormat('EEEE');
    return dateFormat.format(this);
  }

  String formatDateOnly() {
    DateFormat dateFormat = DateFormat('d MMMM y');
    return dateFormat.format(this);
  }
}

extension TimestampExtension on Timestamp {
  String changeToDate() {
    DateFormat date = DateFormat("EEEE, d MMMM, y");
    return date.format(toDate());
  }

  String changeToDateShort() {
    DateFormat date = DateFormat("EE, d MMM, y");
    return date.format(toDate());
  }

  String changeToDateBreak() {
    DateFormat date = DateFormat("EEEE,\nd MMM, y");
    return date.format(toDate());
  }

  String changeToDateTime() {
    DateFormat date = DateFormat("EEEE, d MMMM, y | h:mm a");
    return date.format(toDate());
  }

  String changeToTime() {
    DateFormat time = DateFormat("h:mm a");
    return time.format(toDate());
  }
}

extension StringExtension on String {
  String toStringFix(int i) {
    if (contains(".")) {
      List value = split(".");

      if (value[1] == "0" ||
          value[1] == "00" ||
          value[1] == "000" ||
          value[1] == "0000") {
        return value[0];
      } else {
        String fix = double.parse(this).toStringAsFixed(i);

        if (fix.contains(".")) {
          List split = fix.split(".");

          if (split[1] == "0" ||
              split[1] == "00" ||
              split[1] == "000" ||
              split[1] == "0000") {
            return split[0];
          }
          return fix;
        }
        return "";
      }
    } else {
      return this;
    }
  }

  String toSentence() {
    String value;
    if (length > 1) {
      value = this[0].toUpperCase() + substring(1).toLowerCase();
      return value;
    } else {
      return toUpperCase();
    }
  }

  String toCapitalization() {
    String value = "";
    bool isNumeric(String? s) {
      if (s == null) {
        return false;
      }
      return double.tryParse(s) != null;
    }

    if (contains(" ")) {
      var split = this.split(" ");
      for (var element in split) {
        value =
        "$value ${isNumeric(element) ? element : element.toSentence()}";
      }
    } else {
      value = toSentence();
    }

    return value;
  }
}
