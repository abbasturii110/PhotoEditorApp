import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes_maker/View/CreateQuotes.dart';

import '../Model/TextModel.dart';

List<TextModel> customQuotesList = [];

class WritingQuotes extends StatefulWidget {
  String? author;
  String? quotes;
  WritingQuotes({this.quotes, this.author});
  @override
  _WritingQuotesState createState() => _WritingQuotesState();
}

class _WritingQuotesState extends State<WritingQuotes> {
  List icon = [
    "assets/icons/icon1.png",
    "assets/icons/editIcon.png",
    "assets/icons/center-alignment.png",
    "assets/icons/editIcon2.png"
  ];
  TextEditingController textController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try {
      textController.text = widget.quotes!;
      authorController.text = widget.author!;
      setState(() {});
    } catch (e) {}
  }

  TextAlign align = TextAlign.left;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
                //color: Colors.black,
                borderRadius: BorderRadius.circular(6),
                color: Color(0xffFFFFFF).withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffF9F9F9).withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(-4, 4), // changes position of shadow
                  ),
                ],
                border: Border.all(
                  width: 1,
                  color: Color(0xffFFFFFF).withOpacity(0.4),
                )),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Icon(
              Icons.clear,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                customQuotesList.add(TextModel(
                    x: 50.0,
                    y: 50.0,
                    backgroundColors: Colors.transparent,
                    backgroundShadow: Colors.transparent,
                    rotationSliderValue: 0.0,
                    backgroundCurve: 5,
                    backgroundOpicity: 0.0,
                    strokeColors: Colors.transparent,
                    strokeWidth: 1.0,
                    text: textController.text,
                    author: authorController.text,
                    textStyle: GoogleFonts.alatsi()
                        .copyWith(fontSize: 20, color: Colors.white)));
                setState(() {});
                Get.to(() => CreateQuotes(
                      align: align,
                    ));
              },
              child: Container(
                decoration: BoxDecoration(
                    //color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xffFFFFFF).withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF9F9F9).withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 20,
                        offset: Offset(-4, 4), // changes position of shadow
                      ),
                    ],
                    border: Border.all(
                      width: 1,
                      color: Color(0xffFFFFFF).withOpacity(0.4),
                    )),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Icon(
                  Icons.check,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Text",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Container(
                height: Get.height * 0.15,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: 0.5, color: Color(0xff63B1FA).withOpacity(0.8))),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                    //  hintText: "apply text Here",
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: textController,
                  minLines: 1,

                  // user keyboard will have a button to move cursor to next line
                  //controller: _Textcontroller,
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Author",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Container(
                height: Get.height * 0.07,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: 0.5, color: Color(0xff63B1FA).withOpacity(0.8))),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  style: TextStyle(color: Colors.white),
                  controller: authorController,
                  // user keyboard will have a button to move cursor to next line
                  //controller: _Textcontroller,
                ),
              ),
              SizedBox(
                height: Get.height * 0.06,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Divider(),
                  ...icon.asMap().entries.map((e) => InkWell(
                        onTap: () {
                          if (e.key == 1) {
                            align = TextAlign.left;
                          } else if (e.key == 2) {
                            align = TextAlign.center;
                          } else if (e.key == 3) {
                            align = TextAlign.right;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              //color: Colors.black,
                              borderRadius: BorderRadius.circular(4),
                              color: Color(0xffFFFFFF).withOpacity(0.01),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xffF9F9F9).withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  offset: Offset(
                                      -4, 5), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                width: 1,
                                color: Color(0xffFFFFFF).withOpacity(0.4),
                              )),
                          child: Image.asset(
                            e.value,
                            height: Get.height * 0.02,
                            width: Get.width * 0.05,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
