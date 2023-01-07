import 'package:hive/hive.dart';

part 'local.g.dart';

@HiveType(typeId: 0)
class ThemeModel {
  @HiveField(0)
  final bool? isDark;

  @HiveField(1)
  final String? theme;

  ThemeModel({this.isDark, this.theme});
}

@HiveType(typeId: 1)
class IsUser {
  @HiveField(0)
  final bool? available;

  @HiveField(1)
  final String? user;

  @HiveField(2)
  final bool? biometric;

  @HiveField(3)
  final String? year;

  @HiveField(4)
  final bool? started;

  IsUser({
    this.available,
    this.user,
    this.biometric,
    this.year,
    this.started,
  });
}

@HiveType(typeId: 2)
class CurrentUser {
  @HiveField(0)
  final String? uid;
  @HiveField(1)
  final String? email;
  @HiveField(2)
  final String? username;
  @HiveField(3)
  final String? profile;
  @HiveField(4)
  final String? position;
  @HiveField(5)
  final String? areaID;
  @HiveField(6)
  final String? area;
  @HiveField(7)
  final List? others;

  CurrentUser({
    this.uid,
    this.email,
    this.username,
    this.profile,
    this.position,
    this.areaID,
    this.area,
    this.others,
  });
}
