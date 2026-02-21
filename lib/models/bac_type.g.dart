// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bac_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BacTypeAdapter extends TypeAdapter<BacType> {
  @override
  final int typeId = 0;

  @override
  BacType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BacType.math;
      case 1:
        return BacType.science;
      case 2:
        return BacType.informatique;
      case 3:
        return BacType.lettres;
      case 4:
        return BacType.technique;
      default:
        return BacType.math;
    }
  }

  @override
  void write(BinaryWriter writer, BacType obj) {
    switch (obj) {
      case BacType.math:
        writer.writeByte(0);
        break;
      case BacType.science:
        writer.writeByte(1);
        break;
      case BacType.informatique:
        writer.writeByte(2);
        break;
      case BacType.lettres:
        writer.writeByte(3);
        break;
      case BacType.technique:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BacTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
