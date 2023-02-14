// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FavoriteImageModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteImageModelAdapter extends TypeAdapter<FavoriteImageModel> {
  @override
  final int typeId = 1;

  @override
  FavoriteImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteImageModel(
      image: fields[0] as String?,
      isFavorite: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteImageModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
