import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';

import '../controllers/cloud.dart';
import '../styles/texts.dart';

class AppFunctions {
  AppFunctions._();

  font(double screenWidth, TextStyling textStyle) {
    if (screenWidth <= 395) {
      return textStyle.mediumMuted11;
    } else {
      return textStyle.mediumMuted12;
    }
  }

  sizes(double screenWidth) {
    if (screenWidth > 525) {
      return 410.0;
    } else {
      return screenWidth - 20;
    }
  }

  calcAdd(lists) {
    dynamic total = 0;
    for (var list in lists) {
      total += list;
    }

    return total;
  }

  selectedBack(CloudCtx cloudCtx, BuildContext context) {
    cloudCtx.removeSelected(cloudCtx.section);
    Navigator.pop(context);
  }

  String event(DateTime today) {
    if (today.weekday == DateTime.sunday) {
      return "Sunday Service";
    } else if (today.weekday == DateTime.monday) {
      return "Bible Service";
    } else if (today.weekday == DateTime.thursday) {
      return "Revival Service";
    } else {
      return "Other Service";
    }
  }

  String eventCol(DateTime today) {
    if (today.weekday == DateTime.sunday) {
      return "sundays";
    } else if (today.weekday == DateTime.monday) {
      return "bibles";
    } else if (today.weekday == DateTime.thursday) {
      return "revivals";
    } else {
      return "others";
    }
  }

  String eveCo(DateTime today) {
    if (today.weekday == DateTime.sunday) {
      return "sundays";
    } else if (today.weekday == DateTime.monday) {
      return "bibles";
    } else if (today.weekday == DateTime.thursday) {
      return "revivals";
    } else {
      return "others";
    }
  }

  String greeting() {
    DateTime now = DateTime.now();
    var timeFormat = DateFormat('H');
    var time = int.parse(timeFormat.format(now));

    if (time < 12) {
      return "Good Morning,";
    } else if (time < 16) {
      return "Good Afternoon,";
    } else if (time < 19) {
      return "Good Evening,";
    } else if (time < 24) {
      return "Good Night,";
    } else {
      return "Good Morning,";
    }
  }

  biometrics(List<BiometricType> biometrics) {
    if (biometrics.contains(BiometricType.fingerprint) &&
        biometrics.contains(BiometricType.face)) {
      return "Fingerprint or Facial Recognition";
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return "Fingerprint";
    } else if (biometrics.contains(BiometricType.face)) {
      return "Facial Recognition";
    }
  }

  DateTime changeDate(DateTime datetime) {
    DateTime date = DateTime(datetime.year, datetime.month, datetime.day);
    return date;
  }
}

AppFunctions fxn = AppFunctions._();

extension DoubleExtension on double {
  double removeZero() {
    String value = toString();
    List split = value.split(".");
    if (split.last == "0") {
      return split.first;
    } else {
      return this;
    }
  }
}
