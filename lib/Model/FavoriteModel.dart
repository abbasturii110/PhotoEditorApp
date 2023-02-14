import 'package:hive/hive.dart';

part 'FavoriteModel.g.dart';

@HiveType(typeId: 0)
class FavoriteQuoteModel extends HiveObject {
  @HiveField(0)
  String? quote;
  @HiveField(1)
  String? author;
  @HiveField(2)
  bool? isFavorite;
  FavoriteQuoteModel({
    this.quote,
    this.author,
    this.isFavorite,
  });
}
