import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_maker/Controller/SearchQuotesController.dart';

class AuthorQuotes extends StatefulWidget {
  String? authorName;
  AuthorQuotes({this.authorName});
  @override
  _AuthorQuotesState createState() => _AuthorQuotesState();
}

class _AuthorQuotesState extends State<AuthorQuotes> {
  bool image = true;
  bool quotes = false;

  SearchQuotesController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find();
    controller!.getAutherQuotes(authorName: widget.authorName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          // persistent header
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/image5.jpg",
                fit: BoxFit.cover,
              ),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 25),
                child: Text(widget.authorName.toString()),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: Get.height,
                      // padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: controller!.authorQuotesList!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
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
                                      offset: Offset(
                                          -4, 4), // changes position of shadow
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller!
                                        .authorQuotesList![index].quote!),
                                    SizedBox(
                                      height: Get.height * 0.01,
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(controller!
                                            .authorQuotesList![index].author!)),
                                    Divider(),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 7,
                                                    spreadRadius: 7,
                                                    offset: Offset(-4, 4),
                                                    color: Colors.grey
                                                        .withOpacity(0.4))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: Text(
                                            "Use Templet",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(Icons.share),
                                        SizedBox(
                                          width: Get.width * 0.02,
                                        ),
                                        Icon(Icons.favorite_border),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              )
            ]),
          )
        ],
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
