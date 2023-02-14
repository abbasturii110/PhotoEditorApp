class DrawerModel {
  String? icon;
  String? text;
  DrawerModel({this.icon, this.text});
}

List<DrawerModel> drawerItemList = [
  DrawerModel(icon: "assets/icons/semecolon.png", text: "Quotes"),
  DrawerModel(icon: "assets/icons/write.png", text: "Create Quotes"),
  DrawerModel(icon: "assets/icons/download.png", text: "Save Quotes"),
  DrawerModel(icon: "assets/icons/templete.png", text: "Templete"),
  DrawerModel(icon: "assets/icons/loveing.png", text: "Favorite"),
  DrawerModel(icon: "assets/icons/massaging.png", text: "Contact Us"),
  DrawerModel(icon: "assets/icons/aboutUs.png", text: "About Us"),
  DrawerModel(icon: "assets/icons/privacy.png", text: "Privacy policy"),
];
