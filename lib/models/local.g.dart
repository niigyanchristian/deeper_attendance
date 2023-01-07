// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeModelAdapter extends TypeAdapter<ThemeModel> {
  @override
  final int typeId = 0;

  @override
  ThemeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeModel(
      isDark: fields[0] as bool?,
      theme: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.isDark)
      ..writeByte(1)
      ..write(obj.theme);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IsUserAdapter extends TypeAdapter<IsUser> {
  @override
  final int typeId = 1;

  @override
  IsUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IsUser(
      available: fields[0] as bool?,
      user: fields[1] as String?,
      biometric: fields[2] as bool?,
      year: fields[3] as String?,
      started: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, IsUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.available)
      ..writeByte(1)
      ..write(obj.user)
      ..writeByte(2)
      ..write(obj.biometric)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.started);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IsUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentUserAdapter extends TypeAdapter<CurrentUser> {
  @override
  final int typeId = 2;

  @override
  CurrentUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentUser(
      uid: fields[0] as String?,
      email: fields[1] as String?,
      username: fields[2] as String?,
      profile: fields[3] as String?,
      position: fields[4] as String?,
      areaID: fields[5] as String?,
      area: fields[6] as String?,
      others: (fields[7] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrentUser obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.profile)
      ..writeByte(4)
      ..write(obj.position)
      ..writeByte(5)
      ..write(obj.areaID)
      ..writeByte(6)
      ..write(obj.area)
      ..writeByte(7)
      ..write(obj.others);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
