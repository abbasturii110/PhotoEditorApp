import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes_maker/Controller/SearchQuotesController.dart';
import 'package:quotes_maker/Model/FavoriteModel.dart';
import 'package:quotes_maker/View/WritingQuotes.dart';

import '../Model/QuotesData.dart';
import '../Widgets/Boxes.dart';
import 'AuthorsQuotes.dart';
import 'Favorites.dart';

class SearchQuotes extends StatefulWidget {
  @override
  _SearchQuotesState createState() => _SearchQuotesState();
}

class _SearchQuotesState extends State<SearchQuotes> {
  bool quotes = true;
  bool categories = false;
  bool authors = false;
  // int selectedIndex = 0;
  int hasValue = 0;
  int notContain = 0;
  bool isFavorite = false;
  String? authorName;
  List<QuotesData> items = [];

  List? repeatedCategoriesList = [];
  List? myCategories = [];
  //List<MyCategories>? myCategories = [];
  List repeatedAuthor = [];
  List allAuthor = [];

  SearchQuotesController? controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(SearchQuotesController());
    readJson();
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/quotations.json');
    final data = await json.decode(response);
    print(data);
    List quotesInRaw = [];
    quotesInRaw = data["quotes"] as List;

    quotesInRaw.forEach((element) {
      items.add(QuotesData(
          author: element['author'],
          category: element['category'],
          text: element['text']));
    });

    setState(() {});
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Column(
          children: [
            Container(
              height: Get.height * 0.2,
              width: Get.width,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: Get.height * 0.2,
                    width: Get.width,
                    child: Image.asset(
                      "assets/images/appImage2.jpeg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: Get.height * 0.2,
                    width: Get.width,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 35),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Search Here",
                            hintStyle: GoogleFonts.getFont("Poppins",
                                fontSize: 16, fontWeight: FontWeight.w300),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/icons/Search.png",
                                fit: BoxFit.fill,
                                height: 25,
                                width: 25,
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: Get.height * 0.05,
                width: Get.width,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(width: 1, color: Colors.black)),
                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        items.clear();
                        quotes = true;
                        categories = false;
                        authors = false;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: quotes ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text("Quotes",
                              style: GoogleFonts.getFont("Poppins",
                                  color: quotes ? Colors.white : Colors.grey)),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        myCategories!.clear();
                        quotes = false;
                        categories = true;
                        authors = false;

                        items.forEach((element) {
                          repeatedCategoriesList!.addAll(element.category!);
                        });

                        repeatedCategoriesList!.toSet().forEach((element) {
                          print("This is the element $element");
                          myCategories!.add(element);
                        });

                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: categories ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text("Categories",
                              style: GoogleFonts.getFont("Poppins",
                                  color:
                                      categories ? Colors.white : Colors.grey)),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        allAuthor.clear();
                        quotes = false;
                        categories = false;
                        authors = true;
                        items.forEach((element) {
                          repeatedAuthor.add(element.author);
                        });
                        repeatedAuthor.toSet().forEach((element) {
                          allAuthor.add(element);
                        });
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: authors ? Colors.black : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            "Authors",
                            style: TextStyle(
                                color: authors ? Colors.white : Colors.grey),
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: Get.width * 0.04,
            // ),
            quotes
                ? Obx(() => controller!.isLoading.value
                    ? Container(
                        child: Center(child: CircularProgressIndicator()))
                    : Expanded(
                        child: ValueListenableBuilder<Box<FavoriteQuoteModel>>(
                        valueListenable: Boxes.getFavoriteModel().listenable(),
                        builder: (context, snapshot, i) {
                          List<FavoriteQuoteModel> fav = snapshot.values
                              .toList()
                              .cast<FavoriteQuoteModel>();
                          var keyList = snapshot.keys.toList();
                          return Container(
                            // padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                //itemCount: controller!.quotationData!.length,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.grey.withOpacity(0.25),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: Offset(-4,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(items[index].text.toString(),
                                              style: GoogleFonts.getFont(
                                                  "Poppins",
                                                  shadows: <Shadow>[
                                                    Shadow(
                                                      offset: Offset(
                                                        10.0,
                                                        0,
                                                      ),
                                                      color: Colors.grey,
                                                      blurRadius: 16,
                                                      // color:
                                                      //     Colors.grey.withOpacity(0.3),
                                                    ),
                                                  ],
                                                  // shadows: Shadow(
                                                  //   offset: Offset(10.0, 10.0),
                                                  //   blurRadius: 3.0,
                                                  //   color: Color.fromARGB(255, 0, 0, 0),
                                                  // ),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300)),
                                          SizedBox(
                                            height: Get.height * 0.01,
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                items[index].author.toString(),
                                                style: GoogleFonts.getFont(
                                                    "Poppins"),
                                              )),
                                          Divider(),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Get.to(() => WritingQuotes(
                                                        quotes:
                                                            items[index].text,
                                                        author:
                                                            items[index].author,
                                                      ));
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 35,
                                                            vertical: 6),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              blurRadius: 5,
                                                              spreadRadius: 6,
                                                              offset:
                                                                  Offset(-4, 4),
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.4))
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4)),
                                                    child: Text(
                                                      "Use Templet",
                                                      style:
                                                          GoogleFonts.getFont(
                                                              "Poppins",
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                    )),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.share,
                                                size: 25,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.02,
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    if (keyList
                                                        .contains(index)) {
                                                      Boxes.getFavoriteModel()
                                                          .delete(index);
                                                    } else {
                                                      addFavoriteModel(
                                                          quote:
                                                              items[index].text,
                                                          author: items[index]
                                                              .author,
                                                          isFavorite: true,
                                                          index: index);
                                                      // isFavorite =
                                                      //     fav.contains(index);
                                                    }
                                                    // setState(() {
                                                    //  // isFavorite = !isFavorite;
                                                    // });
                                                  },
                                                  child: keyList.contains(index)
                                                      ? Icon(
                                                          Icons.favorite,
                                                          color: Colors.black,
                                                          size: 25,
                                                        )
                                                      : Icon(
                                                          Icons.favorite_border,
                                                          size: 25)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        },
                      )))
                : SizedBox(),
            categories
                ? Expanded(
                    child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                        itemCount: myCategories!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 01.6,
                            crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              //  selectedIndex = index;
                              setState(() {});
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 400,
                                width: Get.width,
                                color: Colors.grey,
                                child: Stack(
                                  children: [
                                    // Container(
                                    //   height: 400,
                                    //   width: Get.width,
                                    //   decoration: BoxDecoration(
                                    //       image: DecorationImage(
                                    //           image: NetworkImage(
                                    //             controller!.categoryData![index]
                                    //                 .category_image!,
                                    //           ),
                                    //           fit: BoxFit.fill)),
                                    // ),
                                    Container(
                                      height: 400,
                                      width: Get.width,
                                      color: Colors.grey.withOpacity(0.4),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          myCategories![index].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ))
                : SizedBox(),
            authors
                ? Expanded(
                    child: Container(
                    // padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                        // itemCount: controller!.authorData!.length,
                        itemCount: allAuthor.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              authorName =
                                  controller!.authorData![index].author_name;
                              setState(() {
                                print("${controller!.authorData!.length}");
                                print(
                                    "${controller!.authorData![index].author_name}");
                                print(
                                    "${controller!.authorData![index].author_image}");
                                print(
                                    "${controller!.authorData![index].author_id}");
                              });
                              print(
                                  "This is fucking author Value${authorName}");
                              Get.to(() => AuthorQuotes(
                                    authorName: authorName,
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 4,
                                      blurRadius: 5,
                                      offset: Offset(
                                          -4, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(controller!
                                          .authorData![index].author_image!)),
                                  title: Text(
                                    allAuthor[index].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16),
                                  ),
                                  trailing: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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

// List<QuotesModel> appQuotesList = [
//   QuotesModel(
//       quote:
//           "People have the illusion that allover the world,\nall the time, all kinds of fantastic things are\nhappening",
//       author: "David Brinkley"),
//   QuotesModel(
//       quote:
//           "People have the illusion that allover the world,\nall the time, all kinds of fantastic things are\nhappening",
//       author: "David Brinkley"),
//   QuotesModel(
//       quote:
//           "People have the illusion that allover the world,\nall the time, all kinds of fantastic things are\nhappening",
//       author: "David Brinkley"),
//   QuotesModel(
//       quote:
//           "People have the illusion that allover the world,\nall the time, all kinds of fantastic things are\nhappening",
//       author: "David Brinkley"),
//   QuotesModel(
//       quote:
//           "People have the illusion that allover the world,\nall the time, all kinds of fantastic things are\nhappening",
//       author: "David Brinkley"),
//   QuotesModel(
//       quote:
//           "People have the illusion that allover the world,\nall the time, all kinds of fantastic things are\nhappening",
//       author: "David Brinkley"),
// ];
