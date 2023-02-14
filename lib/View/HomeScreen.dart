import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes_maker/Controller/CreateQuotesController.dart';
import 'package:quotes_maker/Controller/HomeController.dart';
import 'package:quotes_maker/Model/DarawerModel.dart';
import 'package:quotes_maker/View/CreateQuotes.dart';
import 'package:quotes_maker/View/Favorites.dart';
import 'package:quotes_maker/View/MyCreates.dart';
import 'package:quotes_maker/View/Quotes_For_You.dart';
import 'package:quotes_maker/View/SearchQuotes.dart';
import 'package:quotes_maker/View/Templets.dart';

import '../Widgets/Widgets.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CreateQuotesController controller = Get.put(CreateQuotesController());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  HomeController? homeController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController = Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: EdgeInsets.only(left: 12, top: 10),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black12.withOpacity(0.04)),
          child: InkWell(
            onTap: () => _scaffoldKey.currentState!.openDrawer(),
            child: Container(
                margin: EdgeInsets.all(8),
                child: Image.asset('assets/icons/ham_menu.png')),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 35),
          //  width: 100,
          child: Column(
            children: [
              Image.asset(
                "assets/images/Rectangle 8133.png",
                fit: BoxFit.fill,
                height: Get.height * 0.18,
                width: Get.width * 0.35,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text("Photo Maker",
                  style: GoogleFonts.poppins().copyWith(
                    color: Color(0xff094D57),
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  )),
              SizedBox(
                height: 20,
              ),
              Divider(
                thickness: 1,
              ),
              ...drawerItemList.asMap().entries.map((e) => Column(
                    children: [
                      Container(
                        child: ListTile(
                          onTap: () {
                            if (e.key == 0) {
                              Get.to(() => SearchQuotes());
                            } else if (e.key == 1) {
                              Get.to(() => MyCreate());
                            } else if (e.key == 2) {
                            } else if (e.key == 3) {
                              Get.to(() => Templets());
                            } else if (e.key == 4) {
                              Get.to(() => Favorites());
                            }
                          },
                          leading: Image.asset(
                            e.value.icon.toString(),
                            height: 30,
                            width: 30,
                          ),
                          title: Text(e.value.text.toString(),
                              style: GoogleFonts.poppins().copyWith(
                                color: Color(0xff094D57),
                                fontSize: 16,
                              )),
                        ),
                      ),
                      e.key == 4 ? Divider() : Container()
                    ],
                  )),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Get.to(() => PScreen());
                },
                child: Container(
                  padding: EdgeInsets.only(left: 12, right: 12, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quote Of The Day",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff094D57)),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Stack(
                          children: [
                            Container(
                              height: Get.height * 0.16,
                              width: Get.width,
                              child: Image.asset(
                                "assets/images/appImage2.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              height: Get.height * 0.16,
                              width: Get.width,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20, bottom: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "People have the illusion that allover the world,all the time, all kinds of fantastic things arehappening",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "David Brinkley",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      text(myText: "Explore"),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          width: Get.width,
                          // height: Get.height * 0.2,
                          // color: Colors.yellow,
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Get.to(() => Templets());
                                          },
                                          child: gridWidget(0)),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Get.to(() => SearchQuotes());
                                          },
                                          child: gridWidget(1)),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Get.to(() => MyCreate());
                                          },
                                          child: gridWidget(2)),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Get.to(() => Favorites());
                                          },
                                          child: gridWidget(3)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Row(
                        children: [
                          Text(
                            "For You",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff094D57)),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Get.to(() => QuotesForYou(
                                    title: "For you",
                                  ));
                            },
                            child: Text(
                              "See All",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff094D57)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              customListView(quotesList),
              SizedBox(
                height: Get.height * 0.03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => QuotesForYou());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        "Picture Quotes",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff094D57)),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => QuotesForYou(
                                title: "Top Chart",
                              ));
                        },
                        child: Text(
                          "See All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff094D57)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.014,
              ),
              customListView(quotesList),
              SizedBox(
                height: Get.height * 0.03,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => QuotesForYou());
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Text(
                        "Backgrounds",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff094D57)),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Get.to(() => QuotesForYou(title: "Backgrounds"));
                        },
                        child: Text(
                          "See All",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff094D57)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              customListView(homeController!.ListOfBackgroundImage),
            ],
          ),
        ),
      ),
    );
  }

  customListView(List list) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      // color: Colors.red,
      margin: EdgeInsets.only(right: 12),
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => Padding(
          padding: index == 0
              ? EdgeInsets.only(left: 12, right: 8)
              : EdgeInsets.only(right: 8),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                onTap: () {
                  controller.backgroundImage.value = list[index];
                  setState(() {});
                  Get.to(() => CreateQuotes());
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red,
                        spreadRadius: 13,
                        blurRadius: 12,
                        offset: Offset(6, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 106,
                  child: Image.asset(
                    list[index].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget gridWidget(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.04),
          borderRadius: BorderRadius.circular(6)),
      height: MediaQuery.of(context).size.height * 0.096,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Image.asset(explore[index].image.toString()),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff8D8686).withOpacity(0.02),

                      spreadRadius: 0,
                      blurRadius: 31,
                      offset: Offset(-3, 5), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(7)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              height: 60,
              width: 60,
            ),
            SizedBox(
              width: Get.width * 0.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(explore[index].title.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Color(0xff094D57))),
                Text(explore[index].subTitle.toString(),
                    style: GoogleFonts.getFont("Poppins",
                        fontSize: 10, fontWeight: FontWeight.w400)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

List quotesList = [
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image7.jpg",
  "assets/images/image2.jpg",
];

List<ExploreModel> explore = [
  ExploreModel(
      image: "assets/icons/themeIcon.png",
      title: "Templet",
      subTitle: "Pick Image"),
  ExploreModel(
      image: "assets/images/Feather.png",
      title: "Quotes",
      subTitle: "Pick Image"),
  ExploreModel(
      image: "assets/icons/imageIcon.png",
      title: "My Create",
      subTitle: "Pick Image"),
  ExploreModel(
      image: "assets/icons/favoriteIcon.png",
      title: "Favorites",
      subTitle: "Pick Image"),
];

class ExploreModel {
  String? image;
  String? title;
  String? subTitle;
  ExploreModel({this.title, this.image, this.subTitle});
}
