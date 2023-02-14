class CategoriesModel {
  String? category_id, category_name, category_image;
  CategoriesModel({this.category_id, this.category_name, this.category_image});
  CategoriesModel.fromJson(Map<String, dynamic> map) {
    category_id = map["category_id"];
    category_name = map["category_name"];
    category_image = map["category_image"];
  }
}
