import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes_maker/Model/FavoriteImageModel.dart';

import '../Model/FavoriteModel.dart';
import '../Widgets/Boxes.dart';

List<FavoriteQuoteModel>? favoriteQuotesList;
List<String>? favoriteImageList;

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool image = true;
  bool quotes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            Container(
              height: Get.height * 0.25,
              width: Get.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/image5.jpg",
                      ),
                      fit: BoxFit.fill)),
              child: Center(
                  child: Text("Favorite",
                      style: GoogleFonts.getFont("Poppins",
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w500))),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 50,
                width: Get.width,
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: Colors.black)),
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        image = true;
                        quotes = false;

                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: image ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Image",
                            style: GoogleFonts.getFont("Poppins",
                                color: image ? Colors.white : Colors.grey),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        image = false;
                        quotes = true;

                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: quotes ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Quotes",
                            style: GoogleFonts.getFont("Poppins",
                                color: quotes ? Colors.white : Colors.grey),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: Get.width * 0.04,
            // ),
            quotes
                ? Expanded(
                    child: ValueListenableBuilder<Box<FavoriteQuoteModel>>(
                    valueListenable: Boxes.getFavoriteModel().listenable(),
                    builder: (context, box, _) {
                      favoriteQuotesList =
                          box.values.toList().cast<FavoriteQuoteModel>();
                      if (favoriteQuotesList!.isEmpty) {
                        return Center(
                          child: Text(
                            'No favourite found.',
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      } else
                        return Container(
                          // padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: favoriteQuotesList!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Container(
                                    // decoration: BoxD,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(favoriteQuotesList![index].quote!,
                                            style: GoogleFonts.getFont(
                                                "Poppins",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300)),
                                        SizedBox(
                                          height: Get.height * 0.01,
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              favoriteQuotesList![index]
                                                  .author!,
                                              style: GoogleFonts.getFont(
                                                  "Poppins"),
                                            )),
                                        Divider(),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 40, vertical: 15),
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              child: Text(
                                                "Use Templet",
                                                style: GoogleFonts.getFont(
                                                    "Poppins",
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Spacer(),
                                            Icon(Icons.share),
                                            SizedBox(
                                              width: Get.width * 0.02,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Boxes.getFavoriteModel()
                                                      .deleteAt(index);
                                                },
                                                child: Icon(Icons.favorite)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                    },
                  ))
                : SizedBox(),
            image
                ? Expanded(
                    child: ValueListenableBuilder<Box<String>>(
                    valueListenable: Hive.box<String>("imageFav").listenable(),
                    builder: (context, box, _) {
                      favoriteImageList =
                          box.values.toList(); //values.toList().cast<String>();
                      if (favoriteImageList!.isEmpty) {
                        return Center(
                          child: Text(
                            'No favourite found.',
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      } else
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                              itemCount: favoriteImageList!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 0.7,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: InkWell(
                                      onDoubleTap: () {
                                        Hive.box<String>("imagefav")
                                            .deleteAt(index);
                                      },
                                      child: Container(
                                        height: Get.height * 0.2,
                                        child: Image.asset(
                                          favoriteImageList![index],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ));
                              }),
                        );
                    },
                  ))
                : SizedBox(),

            // Container(
            //   height: Get.width * 0.1,
            //   width: Get.width,
            //   child: Material(
            //     child: Center(
            //       child: Text(
            //         "For you",
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //     color: Colors.black,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

List favoriteList = [
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image7.jpg",
  "assets/images/image2.jpg",
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image7.jpg",
  "assets/images/image2.jpg",
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image7.jpg",
  "assets/images/image2.jpg",
];

Future addFavoriteModel({
  String? quote,
  String? author,
  bool? isFavorite,
  required int index,
}) async {
  //here we made list to take all the variable (favorite)
  var favoriteModel = FavoriteQuoteModel()
    ..quote = quote
    ..author = author
    ..isFavorite = isFavorite;
  final box = Boxes.getFavoriteModel();
  box.put(index, favoriteModel);
}

Future addFavoriteImageModel({
  String? image,
  bool? isFavorite,
}) async {
  // var favoritImageModel = FavoriteImageModel()
  //   ..image = image
  //   ..isFavorite = isFavorite;
  //final box = Boxes.getFavoriteImageModel();
  Boxes.getFavoriteImageModel()
      .add(FavoriteImageModel(image: image, isFavorite: isFavorite));
//  Boxes.getFavoriteImageModel().add(favoritImageModel);
  //box.add(favoritImageModel);
}

Future? deleteFavouriteModel({FavoriteQuoteModel? model}) {
  try {
    final box = Boxes.getFavoriteModel();
    box.delete(model);
  } catch (e) {
    print(e);
  }
}

Future? deleteFavoiteImageModel({FavoriteImageModel? image}) {
  try {
    final box = Boxes.getFavoriteImageModel();
    box.delete(image);
  } catch (e) {
    print(e);
  }
}
