import 'package:hive/hive.dart';

import '../Model/FavoriteImageModel.dart';
import '../Model/FavoriteModel.dart';

class Boxes {
  static Box<FavoriteQuoteModel> getFavoriteModel() =>
      Hive.box<FavoriteQuoteModel>('favoriteModel');

  static Box<FavoriteImageModel> getFavoriteImageModel() =>
      Hive.box<FavoriteImageModel>('favoriteImageModel');

  //static Box getScreenShotModel() => Hive.box("ScreenShot");
}
