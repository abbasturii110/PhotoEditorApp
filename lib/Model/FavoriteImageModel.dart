import 'package:hive/hive.dart';

part 'FavoriteImageModel.g.dart';

@HiveType(typeId: 1)
class FavoriteImageModel extends HiveObject {
  @HiveField(0)
  String? image;
  @HiveField(1)
  bool? isFavorite = false;
  FavoriteImageModel({this.image, this.isFavorite});
}
