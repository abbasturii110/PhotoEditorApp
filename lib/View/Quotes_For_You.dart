import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes_maker/Controller/SearchQuotesController.dart';
import 'package:quotes_maker/View/SearchQuotes.dart';

class QuotesForYou extends StatefulWidget {
  String? title;
  QuotesForYou({this.title});
  @override
  _QuotesForYouState createState() => _QuotesForYouState();
}

class _QuotesForYouState extends State<QuotesForYou> {
  int heartSelected = 0;
  bool isFavorite = false;
  SearchQuotesController? myController = Get.put(SearchQuotesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        // padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => SearchQuotes());
              },
              child: Container(
                height: Get.height * 0.15,
                width: Get.width,
                margin: EdgeInsets.only(bottom: 10),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      height: Get.height * 0.15,
                      width: Get.width,
                      child: Image.asset(
                        "assets/images/appImage2.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: Get.height * 0.15,
                      width: Get.width,
                      color: Colors.black.withOpacity(0.4),
                    ),
                    Center(
                      child: Text(
                        widget.title!,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: ValueListenableBuilder<Box<String>>(
              valueListenable: Hive.box<String>("imageFav").listenable(),
              builder: (context, snapshot, _) {
                List<String> forYourFav =
                    snapshot.values.toList().cast<String>();
                //   List favorites   = snapshot.values.toList().cast<FavoriteImageModel>();

                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: GridView.builder(
                      // shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: forYouList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: InkWell(
                                onTap: () {
                                  if (forYourFav.contains(forYouList[index])) {
                                    Hive.box<String>("imageFav")
                                        .delete(forYouList[index]);
                                  } else {
                                    Hive.box<String>("imageFav").put(
                                        forYouList[index], forYouList[index]);
                                  }

                                  // print("This is fucking image ${forYourFav[0].image}");
                                  // print(
                                  //     "This is fucking value ${forYourFav[0].isFavorite}");
                                  // Box? box;
                                  // isFavorite = box!.get(index,
                                  //     defaultValue: FavoriteImageModel()
                                  //       ..isFavorite);
                                  heartSelected = index;
                                  setState(() {});
                                  //setState(() {});
                                },
                                child: Container(
                                  //height: Get.height * 0.25,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                            forYouList[index],
                                          ),
                                          fit: BoxFit.fill)),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, top: 10),
                                        child: Icon(
                                          forYourFav.contains(forYouList[index])
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 20,
                                        ),
                                      )),
                                )));
                      }),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}

List forYouList = [
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image7.jpg",
  "assets/images/image2.jpg",
];
