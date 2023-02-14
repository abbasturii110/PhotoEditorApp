import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outlined_text/models/outlined_text_stroke.dart';
import 'package:outlined_text/outlined_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quotes_maker/Controller/CreateQuotesController.dart';
import 'package:quotes_maker/Model/StickerModel.dart';
import 'package:quotes_maker/View/SearchQuotes.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';

import '../Model/EmojiModel.dart';
import '../Widgets/CreateQuotesDATA.dart';
import 'WritingQuotes.dart';

class CreateQuotes extends StatefulWidget {
  TextAlign? align = TextAlign.left;

  CreateQuotes({
    this.align,
  });
  @override
  _CreateQuotesState createState() => _CreateQuotesState();
}

class _CreateQuotesState extends State<CreateQuotes> {
  var height = AppBar().preferredSize.height;

  Color color1 = Colors.white;
  Color color2 = Colors.yellow;

  Color textColor = Colors.white;

  double fontSizeValue = 0.0;

  int fontClickIndex = 0;
  bool removeEdit = false;

  File? file;
  String? imagePath;
  final ImagePicker imagePicker = ImagePicker();
  Future<void> PickImageGallery(BuildContext context) async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image.path;
        file = File(image.path);
        //  submit();
      });
    }
  }

  Future<void> PickImageCamera(BuildContext context) async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        imagePath = image.path;
        file = File(image.path);
        //  submit();
      });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      PickImageGallery(context);
                      Get.back();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      PickImageCamera(context);
                      Get.back();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  CreateQuotesController? myController = Get.put(CreateQuotesController());

  final TextEditingController _controller = TextEditingController();
  bool emojiShowing = false;
  _onBackspacePressed() {
    _controller
      ..text = _controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
    myController!.isEmojiVisable.value = !myController!.isEmojiVisable.value;
  }

  _onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length));
  }

  TextStyle textStyle =
      GoogleFonts.alatsi().copyWith(fontSize: 20, color: Colors.white);
  bool onBold = false;
  int photoGalleryItemsClick = 0;
  int propertiesItemsClick = 0;
  final screenShotController = ScreenshotController();
  AppBar? appBar;
  CreateQuotesController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        myController!.emojiList.clear();
        customQuotesList.clear();
        stickerList.clear();
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                    // color: Color(0xffFFFFFF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffF9F9F9).withOpacity(0.2),
                        // spreadRadius: 3,
                        blurRadius: 20,
                        offset: Offset(-4, 4), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: Color(0xffFFFFFF).withOpacity(0.45),
                    )),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Icon(
                  Icons.arrow_back,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () async {
                  removeEdit = true;
                  setState(() {});
                  final image = await screenShotController.capture();

                  final tempDir = await getTemporaryDirectory();
                  File file = await File('${tempDir.path}/image.png').create();

                  file.writeAsBytes(image!).then((value) {
                    Share.shareFiles(['${value.path}']);
                  });
                  //  String s = new String.fromCharCodes(image!);
                  //  print("This is the Image string in dart${s}");
                  // Share.shareFiles(["${file}"]);
                },
                child: Container(
                  decoration: BoxDecoration(
                      // color: Color(0xffFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xffF9F9F9).withOpacity(0.2),
                          // spreadRadius: 3,
                          blurRadius: 20,
                          offset: Offset(-4, 4), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: Color(0xffFFFFFF).withOpacity(0.45),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Icon(
                    Icons.ios_share,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  // setState(() {});
                },
                child: InkWell(
                  onTap: () async {
                    removeEdit = true;
                    setState(() {});
                    final image = await screenShotController.capture();
                    if (image == null) return;
                    await saveImage(image).then((value) {
                      Get.snackbar("Message", "Screen shot",
                          colorText: Colors.white);
                      removeEdit = false;
                    });
                    final tempDir = await getTemporaryDirectory();
                    File file = await File(
                            '${tempDir.path}/${DateTime.now().millisecond}.png')
                        .create();
                    //  final box = Hive.box("ScreenShot");
                    file.writeAsBytes(image).then((value) {
                      print('my orginal image  path is : ${value.path}');
                      Hive.box<String>("ScreenShot").add(value.path);
                    });
                  },
                  // /data/user/0/com.example.quotes_maker/cache/image.png
                  child: Container(
                    decoration: BoxDecoration(
                        // color: Color(0xffFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffF9F9F9).withOpacity(0.2),
                            // spreadRadius: 3,
                            blurRadius: 20,
                            offset: Offset(-4, 4), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: Color(0xffFFFFFF).withOpacity(0.45),
                        )),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: Icon(
                      Icons.download_outlined,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: Get.height,
          width: Get.width,
          child: Stack(
            children: [
              Screenshot(
                controller: screenShotController,
                child: Stack(
                  children: [
                    Container(
                      height: Get.height,
                      width: Get.width,
                      color: Colors.grey,
                      child: imagePath == null
                          ? ColorFiltered(
                              colorFilter: ColorFilter.matrix(assignFilter),
                              child: Image.asset(
                                controller.backgroundImage.value.isEmpty
                                    ? "assets/images/image3.jpg"
                                    : controller.backgroundImage.value,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ColorFiltered(
                              colorFilter: ColorFilter.matrix(assignFilter),
                              child: Image.file(
                                file!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),

                    ...myController!.emojiList.asMap().entries.map((e) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            myController!.selectedIndex = e.key;
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              Container(
                                child: Positioned(
                                  top: e.value.y,
                                  left: e.value.x,
                                  child: Draggable(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.03,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  //  e.value.text = "";
                                                  //quotesLis[0] = "";
                                                  myController!.emojiList
                                                      .removeAt(e.key);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 0.1,
                                                      color: myController!
                                                                      .emojiList[
                                                                  e.key] ==
                                                              ""
                                                          ? Colors.transparent
                                                          : removeEdit == true
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.grey,
                                                    )),
                                                child: Icon(
                                                  Icons.clear,
                                                  color: myController!
                                                                  .emojiList[
                                                              e.key] ==
                                                          ""
                                                      ? Colors.transparent
                                                      : removeEdit == true
                                                          ? Colors.transparent
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              // color: customQuotesList[e.key]
                                              //     .backgroundColors!
                                              //     .withOpacity(
                                              //         customQuotesList[e.key]
                                              //             .backgroundOpicity!),
                                              // borderRadius:
                                              //     BorderRadius.circular(
                                              //         customQuotesList[e.key]
                                              //             .backgroundCurve!),
                                              border: Border.all(
                                            width: 0.3,
                                            color: myController!
                                                        .emojiList[e.key] ==
                                                    ""
                                                ? Colors.transparent
                                                : removeEdit == true
                                                    ? Colors.transparent
                                                    : Colors.grey,
                                          )),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            myController!.emojiList[e.key]
                                                .emojiController
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: myController!
                                                    .emojiList[e.key]
                                                    .emojiSize),
                                          ),
                                        ),
                                      ],
                                    ),
                                    feedback: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        myController!
                                            .emojiList[e.key].emojiController
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: myController!
                                                .emojiList[e.key].emojiSize),
                                      ),
                                    ),
                                    childWhenDragging: Container(
                                      height: 40,
                                      width: 200,
                                    ),
                                    // onDragUpdate: (dd) {
                                    //   setState(() {
                                    //     e.value.x = dd.localPosition.dx;
                                    //     e.value.y = dd.localPosition.dy;
                                    //   });
                                    // },
                                    onDragEnd: (dragDetails) {
                                      setState(
                                        () {
                                          e.value.x = dragDetails.offset.dx;
                                          // We need to remove offsets like app/status bar from Y
                                          e.value.y =
                                              dragDetails.offset.dy - 60;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    //orignal
                    ...customQuotesList.asMap().entries.map((e) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            myController!.selectedIndex = e.key;
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              Container(
                                child: Positioned(
                                  top: e.value.y,
                                  left: e.value.x,
                                  child: Draggable(
                                    child: RotationTransition(
                                      turns: new AlwaysStoppedAnimation(
                                          customQuotesList[e.key]
                                                  .rotationSliderValue! /
                                              360),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.03,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    customQuotesList
                                                        .removeAt(e.key);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        width: 0.1,
                                                        color: e.value.text ==
                                                                ""
                                                            ? Colors.transparent
                                                            : removeEdit == true
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.grey,
                                                      )),
                                                  child: Icon(
                                                    Icons.clear,
                                                    color: e.value.text == ""
                                                        ? Colors.transparent
                                                        : removeEdit == true
                                                            ? Colors.transparent
                                                            : Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: customQuotesList[e.key]
                                                    .backgroundColors!
                                                    .withOpacity(
                                                        customQuotesList[e.key]
                                                            .backgroundOpicity!),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        customQuotesList[e.key]
                                                            .backgroundCurve!),
                                                border: Border.all(
                                                  width: 0.3,
                                                  color: e.value.text == ""
                                                      ? Colors.transparent
                                                      : removeEdit == true
                                                          ? Colors.transparent
                                                          : Colors.grey,
                                                )),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Container(
                                                  // width: Get.width,
                                                  child: OutlinedText(
                                                    text: Text(
                                                        e.value.text.toString(),
                                                        textAlign: widget.align,
                                                        maxLines: 4,
                                                        softWrap: false,
                                                        overflow:
                                                            textStyle.overflow,
                                                        style: e
                                                            .value.textStyle!
                                                            .copyWith(
                                                          shadows: <Shadow>[
                                                            Shadow(
                                                              offset: Offset(
                                                                10,
                                                                0,
                                                              ),
                                                              color: customQuotesList[
                                                                      myController!
                                                                          .selectedIndex]
                                                                  .backgroundShadow!,
                                                              blurRadius: customQuotesList[
                                                                      myController!
                                                                          .selectedIndex]
                                                                  .xAxisSliderValue,
                                                              // color:
                                                              //     Colors.grey.withOpacity(0.3),
                                                            ),
                                                          ],
                                                        )),
                                                    strokes: [
                                                      OutlinedTextStroke(
                                                          color:
                                                              customQuotesList[
                                                                      e.key]
                                                                  .strokeColors,
                                                          width:
                                                              customQuotesList[
                                                                      e.key]
                                                                  .strokeWidth),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  e.value.author.toString(),
                                                  style: e.value.textStyle,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    feedback: Cirule(
                                        index: e.key,
                                        text: e.value.text,
                                        author: e.value.author,
                                        textStyle: e.value.textStyle,
                                        removeEdit: false),
                                    childWhenDragging: Container(
                                      height: 40,
                                      width: 200,
                                    ),
                                    // onDragUpdate: (dd) {
                                    //   setState(() {
                                    //     e.value.x = dd.localPosition.dx;
                                    //     e.value.y = dd.localPosition.dy;
                                    //   });
                                    // },
                                    onDragEnd: (dragDetails) {
                                      setState(
                                        () {
                                          e.value.x = dragDetails.offset.dx;
                                          // We need to remove offsets like app/status bar from Y
                                          e.value.y =
                                              dragDetails.offset.dy - 60;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    ...stickerList.asMap().entries.map((e) {
                      return Container(
                        child: GestureDetector(
                          onTap: () {
                            myController!.selectedIndex = e.key;
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              Container(
                                child: Positioned(
                                  top: e.value.y,
                                  left: e.value.x,
                                  child: Draggable(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.03,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  //  e.value.text = "";
                                                  //quotesLis[0] = "";
                                                  stickerList.removeAt(e.key);
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      width: 0.1,
                                                      color: stickerList[
                                                                  e.key] ==
                                                              ""
                                                          ? Colors.transparent
                                                          : removeEdit == true
                                                              ? Colors
                                                                  .transparent
                                                              : Colors.grey,
                                                    )),
                                                child: Icon(
                                                  Icons.clear,
                                                  color: stickerList[e.key] ==
                                                          ""
                                                      ? Colors.transparent
                                                      : removeEdit == true
                                                          ? Colors.transparent
                                                          : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              // color: customQuotesList[e.key]
                                              //     .backgroundColors!
                                              //     .withOpacity(
                                              //         customQuotesList[e.key]
                                              //             .backgroundOpicity!),
                                              // borderRadius:
                                              //     BorderRadius.circular(
                                              //         customQuotesList[e.key]
                                              //             .backgroundCurve!),
                                              border: Border.all(
                                            width: 0.3,
                                            color: stickerList[e.key] == ""
                                                ? Colors.transparent
                                                : removeEdit == true
                                                    ? Colors.transparent
                                                    : Colors.grey,
                                          )),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Container(
                                            height:
                                                stickerList[e.key].stickerSize,
                                            // width: 100,
                                            child: Image.asset(
                                                stickerList[e.key]
                                                    .sticker
                                                    .toString()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    feedback: Container(
                                      height: stickerList[e.key].stickerSize,
                                      // width: 100,
                                      child: Image.asset(stickerList[e.key]
                                          .sticker
                                          .toString()),
                                    ),
                                    childWhenDragging: Container(
                                      height: 40,
                                      width: 200,
                                    ),
                                    // onDragUpdate: (dd) {
                                    //   setState(() {
                                    //     e.value.x = dd.localPosition.dx;
                                    //     e.value.y = dd.localPosition.dy;
                                    //   });
                                    // },
                                    onDragEnd: (dragDetails) {
                                      setState(
                                        () {
                                          e.value.x = dragDetails.offset.dx;
                                          // We need to remove offsets like app/status bar from Y
                                          e.value.y =
                                              dragDetails.offset.dy - 120;
                                          e.value.x =
                                              dragDetails.offset.dx - 10;
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black,
                  height: Get.height * 0.2,
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        myController!.bottomSheetName.value,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Divider(
                        color: Color(0xff63B1FA).withOpacity(0.5),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Container(
                        height: Get.height * 0.1,
                        // color: Colors.pink,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: editList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  photoGalleryItemsClick = index;
                                  setState(() {});
                                  if (index == 0) {
                                    myController!.bottomSheetName.value =
                                        "Search Quotes";
                                    await Get.to(() => SearchQuotes());
                                  } else if (index == 1) {
                                    _showChoiceDialog(context);

                                    setState(() {});
                                  } else if (index == 2) {
                                    myController!.bottomSheetName.value =
                                        "Writing Quotes";
                                    Get.to(() => WritingQuotes());
                                  } else if (index == 3) {
                                    myController!.bottomSheetName.value =
                                        "Backgrounds";
                                    if (customQuotesList.length == 0) {
                                      Get.snackbar("Wrong", "You have not text",
                                          snackPosition: SnackPosition.TOP);

                                      return;
                                    }
                                    customColorPicker();
                                  } else if (index == 4) {
                                    myController!.bottomSheetName.value =
                                        "Fonts";
                                    customFontBottomSheet();
                                  } else if (index == 8) {
                                    myController!.bottomSheetName.value =
                                        "Rotation";
                                    if (customQuotesList.length == 0) {
                                      Get.snackbar("Wrong", "You have not text",
                                          snackPosition: SnackPosition.TOP);
                                      return;
                                    }
                                    rotationBottomSheet();
                                  } else if (index == 9) {
                                    stickerPicker();
                                    myController!.bottomSheetName.value =
                                        "Stickers";
                                  } else if (index == 6) {
                                    myController!.bottomSheetName.value =
                                        "Filter";
                                    customFilter();

                                    // setState(() {});
                                  } else if (index == 7) {
                                    myController!.bottomSheetName.value =
                                        "Stroke";
                                    if (customQuotesList.length == 0) {
                                      Get.snackbar("Wrong", "You have not text",
                                          snackPosition: SnackPosition.TOP);
                                      return;
                                    }
                                    StrokePicker();
                                  } else if (index == 5) {
                                    myController!.bottomSheetName.value =
                                        "Properties";
                                    print(
                                        "I'm exected ${customQuotesList.isEmpty && myController!.emojiList.isEmpty && stickerList.isEmpty && fontSizeValue == 0}");
                                    if (customQuotesList.isEmpty &&
                                        myController!.emojiList.isEmpty &&
                                        stickerList.isEmpty &&
                                        fontSizeValue == 0) {
                                      Get.snackbar("Wrong", "No Item Selected");
                                      return;
                                    }
                                    propertiesBottomSheet();
                                  } else if (index == 10) {
                                    setState(() {
                                      //  emojiShowing = !emojiShowing;
                                      myController!.isEmojiVisable.value =
                                          !myController!.isEmojiVisable.value;
                                    });
                                  } else if (index == 11) {
                                    myController!.bottomSheetName.value =
                                        "Shadow Picker";
                                    if (customQuotesList.isEmpty &&
                                        myController!.emojiList.isEmpty &&
                                        stickerList.isEmpty &&
                                        fontSizeValue == 0) {
                                      Get.snackbar("Wrong", "No Item Selected");
                                      return;
                                    }
                                    shadowPicker();
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 15, bottom: 15),
                                  child: Container(
                                    height: 50,
                                    width: 60,

                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 10, vertical: 7),
                                    decoration: BoxDecoration(
                                        // color: Color(0xffFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xffF9F9F9)
                                                .withOpacity(0.2),
                                            spreadRadius: 0,
                                            blurRadius: 20,
                                            offset: Offset(-4,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1,
                                          color: photoGalleryItemsClick == index
                                              ? Color(0xff63B1FA)
                                              : Color(0xffFFFFFF)
                                                  .withOpacity(0.45),
                                        )),
                                    child: Center(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 15),
                                        child: Image.asset(
                                          editList[index],
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Obx(() => Offstage(
                      offstage: myController!.isEmojiVisable.value,
                      child: SizedBox(
                        height: 250,
                        child: EmojiPicker(
                            onEmojiSelected: (category, emoji) {
                              print(
                                  "This is the selected value ${myController!.isEmojiVisable.value}");
                              // emojiList.add(emoji.emoji);
                              _onEmojiSelected(emoji);
                              myController!.emojiList.add(EmojiModel(
                                emojiController: emoji.emoji,
                                x: 50.0,
                                y: 50.0,
                                emojiSize: 50,
                                isSelected: false,
                              ));

                              setState(() {});
                            },
                            onBackspacePressed: _onBackspacePressed,
                            config: Config(
                                columns: 7,
                                // Issue: https://github.com/flutter/flutter/issues/28894
                                emojiSizeMax:
                                    32 * (Platform.isIOS ? 1.30 : 1.0),
                                verticalSpacing: 0,
                                horizontalSpacing: 0,
                                initCategory: Category.RECENT,
                                bgColor: const Color(0xFFF2F2F2),
                                indicatorColor: Colors.blue,
                                iconColor: Colors.grey,
                                iconColorSelected: Colors.blue,
                                progressIndicatorColor: Colors.blue,
                                backspaceColor: Colors.blue,
                                skinToneDialogBgColor: Colors.white,
                                skinToneIndicatorColor: Colors.grey,
                                enableSkinTones: true,
                                showRecentsTab: true,
                                recentsLimit: 28,
                                noRecentsText: 'No Recents',
                                noRecentsStyle: const TextStyle(
                                    fontSize: 20, color: Colors.black26),
                                tabIndicatorAnimDuration: kTabScrollDuration,
                                categoryIcons: const CategoryIcons(),
                                buttonMode: ButtonMode.MATERIAL)),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  customFontBottomSheet() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.32,
                width: Get.width,
                // margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Fonts",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    // SizedBox(
                    //   height: Get.height * 0.02,
                    // ),
                    Expanded(
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 20),
                        height: Get.height * 0.2,
                        width: Get.width,
                        child: GridView.builder(
                            itemCount: myController!.fontsList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 0,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 3.5,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: InkWell(
                                  onTap: () {
                                    fontClickIndex = index;
                                    //  textStyle = myController!.fontList[index];
                                    textStyle = TextStyle(
                                        fontFamily:
                                            myController!.fontsList[index]);
                                    customQuotesList[
                                                myController!.selectedIndex]
                                            .textStyle =
                                        textStyle.copyWith(color: color1);

                                    // customQuotesList[myController!.selectedIndex]
                                    //     .textStyle =
                                    //     customQuotesList[myController!.selectedIndex]
                                    //         .textStyle!
                                    //         .copyWith(color: color1);

                                    setState(() {});

                                    state(() {});
                                  },
                                  child: Container(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        myController!.fontsList[index]
                                            .replaceFirst("-Regular", ""),
                                        // style: myController!.fontList[index]
                                        //     .copyWith(color: Colors.white),
                                        style: TextStyle(
                                            fontFamily:
                                                myController!.fontsList[index],
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        // color: Color(0xffFFFFFF),
                                        color: fontClickIndex == index
                                            ? Color(0xff63B1FA)
                                            : Color(0xffFFFFFF)
                                                .withOpacity(0.1),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xffF9F9F9)
                                                .withOpacity(0.2),
                                            // spreadRadius: 3,
                                            blurRadius: 20,
                                            offset: Offset(-4,
                                                4), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1,
                                          color: Color(0xffFFFFFF)
                                              .withOpacity(0.45),
                                        )),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  propertiesBottomSheet() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.45,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Properties",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Emoji:",
                            style: TextStyle(color: Colors.white),
                          ),
                          Divider(color: Color(0xff63B1FA4D)),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Container(
                            width: Get.width * 0.7,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: myController!.emojiList.length != 0
                                    ? myController!
                                        .emojiList[myController!.selectedIndex]
                                        .emojiSize!
                                    : 0.0,
                                max: 100,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                onChanged: (double value) {
                                  myController!
                                      .emojiList[myController!.selectedIndex]
                                      .emojiSize = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Stack :",
                            style: TextStyle(color: Colors.white),
                          ),
                          Divider(color: Color(0xff63B1FA4D)),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Container(
                            width: Get.width * 0.7,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: stickerList.length != 0
                                    ? stickerList[myController!.selectedIndex]
                                        .stickerSize!
                                    : 0.0,
                                max: 360,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                onChanged: (double value) {
                                  stickerList[myController!.selectedIndex]
                                      .stickerSize = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Font Size :",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            width: Get.width * 0.65,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: fontSizeValue,
                                max: 100,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  fontSizeValue = value;
                                  //  myValue = value;
                                  customQuotesList[myController!.selectedIndex]
                                      .textStyle = customQuotesList[
                                          myController!.selectedIndex]
                                      .textStyle!
                                      .copyWith(fontSize: fontSizeValue);

                                  // setState(() {});
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FastColorPicker(
                      selectedColor: textColor,
                      onColorSelected: (color) {
                        textColor = color;
                        customQuotesList[myController!.selectedIndex]
                                .textStyle =
                            customQuotesList[myController!.selectedIndex]
                                .textStyle!
                                .copyWith(color: textColor);
                        setState(() {});
                        state(() {});
                      },
                    ),
                    Container(
                      height: 75,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: propertiesList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                propertiesItemsClick = index;
                                setState(() {});
                                state(() {});

                                if (index == 0) {
                                  makeTextBold();
                                } else if (index == 1) {
                                  makeTextItalic();
                                } else if (index == 2) {
                                  makeTextBaseLine();
                                } else if (index == 3) {
                                  makeTextOverLine();
                                } else if (index == 4) {
                                  if (myController!.selectedIndex == index) {
                                    widget.align = TextAlign.left;
                                  }
                                  setState(() {});
                                  state(() {});
                                } else if (index == 5) {
                                  if (myController!.selectedIndex == index) {
                                    widget.align = TextAlign.center;
                                  }
                                  setState(() {});
                                  state(() {});
                                } else if (index == 6) {
                                  if (myController!.selectedIndex == index) {
                                    widget.align = TextAlign.right;
                                  }
                                  setState(() {});
                                  state(() {});
                                }

                                return;
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 15, bottom: 15),
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 10, vertical: 7),
                                  decoration: BoxDecoration(
                                      // color: Color(0xffFFFFFF),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xffF9F9F9)
                                              .withOpacity(0.2),
                                          spreadRadius: 0,
                                          blurRadius: 20,
                                          offset: Offset(-4,
                                              4), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: propertiesItemsClick == index
                                            ? Color(0xff63B1FA)
                                            : Color(0xffFFFFFF)
                                                .withOpacity(0.45),
                                      )),
                                  child: Center(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      child: Image.asset(
                                        propertiesList[index],
                                        // height: Get.height * 0.0,
                                        // width: Get.width * 0.08,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  rotationBottomSheet() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.2,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Rotation",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rotation:",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: customQuotesList[
                                        myController!.selectedIndex]
                                    .rotationSliderValue!,
                                max: 360,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  customQuotesList[myController!.selectedIndex]
                                      .rotationSliderValue = value;

                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  customFilter() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.2,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Filters",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Container(
                      height: 70,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: filterPages.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                assignFilter = filters[index];
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    width: 80,
                                    // height: 40,
                                    decoration: BoxDecoration(
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //       color: Colors.white,
                                        //       blurRadius: 2,
                                        //       offset: Offset(-4, 4),
                                        //       spreadRadius: 30)
                                        // ],
                                        ),
                                    child: ColorFiltered(
                                        colorFilter:
                                            ColorFilter.matrix(filters[index]),
                                        child: Image.asset(
                                          filterPages[index].toString(),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  customColorPicker() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.32,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Backgrounds",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     ...backgroundSheetlist.asMap().entries.map(
                    //           (e) => Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 10),
                    //             child: Container(
                    //               height: 50,
                    //               width: 50,
                    //               // padding: EdgeInsets.symmetric(
                    //               //     horizontal: 10, vertical: 7),
                    //               decoration: BoxDecoration(
                    //                   // color: Colors.black,
                    //                   borderRadius: BorderRadius.circular(6),
                    //                   color: Color(0xffFFFFFF).withOpacity(0.1),
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                       color: Color(0xffF9F9F9)
                    //                           .withOpacity(0.3),
                    //                       spreadRadius: 0,
                    //                       blurRadius: 20,
                    //                       offset: Offset(-4,
                    //                           4), // changes position of shadow
                    //                     ),
                    //                   ],
                    //                   border: Border.all(
                    //                     width: 1,
                    //                     color:
                    //                         Color(0xffFFFFFF).withOpacity(0.4),
                    //                   )),
                    //               child: Center(
                    //                 child: Container(
                    //                   margin: EdgeInsets.symmetric(
                    //                       horizontal: 4, vertical: 8),
                    //                   child: Image.asset(
                    //                     e.value,
                    //                     // height: Get.height * 0.0,
                    //                     // width: Get.width * 0.08,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //   ],
                    // ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Opicity",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: customQuotesList[
                                        myController!.selectedIndex]
                                    .backgroundOpicity!,
                                max: 1,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  customQuotesList[myController!.selectedIndex]
                                      .backgroundOpicity = value;
                                  setState(() {});

                                  state(() {});
                                  customQuotesList[myController!.selectedIndex]
                                      .backgroundOpicity = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Curve",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: customQuotesList[
                                        myController!.selectedIndex]
                                    .backgroundCurve!,
                                max: 100,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  customQuotesList[myController!.selectedIndex]
                                      .backgroundCurve = value;
                                  setState(() {});

                                  state(() {});
                                  customQuotesList[myController!.selectedIndex]
                                      .backgroundCurve = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // customBackgroundSlider(
                    //     sliderName: "Opicity",
                    //     myValue: customQuotesList[myController!.selectedIndex]
                    //         .backgroundOpicity,action: 1),
                    //
                    // customBackgroundSlider(
                    //     sliderName: "Curve",
                    //     myValue: customQuotesList[myController!.selectedIndex]
                    //         .backgroundCurve,action: 2),
                    FastColorPicker(
                      selectedColor: color2,
                      onColorSelected: (color) {
                        color2 = color;
                        customQuotesList[myController!.selectedIndex]
                            .backgroundColors = color2;
                        setState(() {});
                        state(() {});
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  StrokePicker() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.4,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Stroke",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Divider(
                      thickness: 1,
                      color: Color(0xff63B1FA).withOpacity(0.6),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    // customStrokPickerSlider(
                    //     "Stroke",
                    //     customQuotesList[myController!.selectedIndex]
                    //         .strokeWidth!),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Stroke",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: customQuotesList[
                                        myController!.selectedIndex]
                                    .strokeWidth!,
                                max: 20,

                                divisions: 100,
                                label: customQuotesList[
                                        myController!.selectedIndex]
                                    .strokeWidth!
                                    .toString(),
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  customQuotesList[myController!.selectedIndex]
                                      .strokeWidth = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        FastColorPicker(
                          selectedColor:
                              customQuotesList[myController!.selectedIndex]
                                  .strokeColors!,
                          onColorSelected: (color) {
                            customQuotesList[myController!.selectedIndex]
                                .strokeColors = color;
                            setState(() {});
                            state(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  stickerPicker() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.black,
                height: Get.height * 0.4,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Sticker",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Divider(
                      thickness: 1,
                      color: Color(0xff63B1FA).withOpacity(0.4),
                    ),
                    Expanded(
                      child: GridView.builder(
                          itemCount: sticker.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4),
                          itemBuilder: (context, index) {
                            return Container(
                              child: InkWell(
                                onTap: () {
                                  stickerList.add(StickerModel(
                                      x: 50,
                                      y: 50,
                                      sticker: sticker[index],
                                      stickerSize: 45));
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff63B1FA87)),
                                      borderRadius: BorderRadius.circular(4)),
                                  padding: EdgeInsets.all(15),
                                  child: Image.asset(
                                    sticker[index],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  filterPicker() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.4,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Filter",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Divider(
                      thickness: 1,
                      color: Color(0xff63B1FA).withOpacity(0.4),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  customStrokPickerSlider(String title, double myValue) {
    return StatefulBuilder(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 1,
                  ),
                  child: Slider(
                    value: myValue,
                    max: 100,

                    divisions: 100,
                    label: customQuotesList[myController!.selectedIndex]
                        .strokeWidth!
                        .toString(),
                    inactiveColor: Colors.white.withOpacity(0.4),
                    //label: value,
                    onChanged: (double value) {
                      myValue = value;
                      setState(() {});
                      state(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  customShadow(String title, double myValue) {
    return StatefulBuilder(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 1,
                  ),
                  child: Slider(
                    value: myValue,
                    max: 100,

                    divisions: 100,
                    // label: customQuotesList[myController!.selectedIndex]
                    //     .blurSliderValue!
                    // .toString(),
                    inactiveColor: Colors.white.withOpacity(0.4),
                    //label: value,
                    onChanged: (double value) {
                      myValue = value;
                      setState(() {});
                      state(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void makeTextBold() {
    if (customQuotesList[myController!.selectedIndex].textStyle!.fontWeight !=
        FontWeight.bold) {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(fontWeight: FontWeight.bold);
    } else {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(fontWeight: FontWeight.normal);
    }
    setState(() {});
  }

  void makeTextItalic() {
    if (customQuotesList[myController!.selectedIndex].textStyle!.fontStyle !=
        FontStyle.italic) {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(fontStyle: FontStyle.italic);
    } else {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(fontStyle: FontStyle.normal);
    }
    setState(() {});
  }

  void makeTextBaseLine() {
    TextDecoration? currentDecoration =
        customQuotesList[myController!.selectedIndex].textStyle!.decoration;
    if (currentDecoration != TextDecoration.underline ||
        currentDecoration == null) {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(decoration: TextDecoration.underline);
    } else {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(decoration: TextDecoration.none);
    }
    setState(() {});
  }

  void makeTextOverLine() {
    TextDecoration? currentDecoration =
        customQuotesList[myController!.selectedIndex].textStyle!.decoration;
    if (currentDecoration != TextDecoration.lineThrough ||
        currentDecoration == null) {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(decoration: TextDecoration.lineThrough);
    } else {
      customQuotesList[myController!.selectedIndex].textStyle =
          customQuotesList[myController!.selectedIndex]
              .textStyle!
              .copyWith(decoration: TextDecoration.none);
    }
    setState(() {});
  }

  customBackgroundSlider({String? sliderName, double? myValue, int? action}) {
    //action = 1 means opacity
    //action = 2 means curve

    return StatefulBuilder(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                sliderName!,
                style: TextStyle(color: Colors.white),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 1,
                  ),
                  child: Slider(
                    value: myValue!,
                    max: 100,
                    divisions: 100,
                    inactiveColor: Colors.white.withOpacity(0.4),
                    //label: value,
                    onChanged: (double value) {
                      switch (action) {
                        case 1:
                          customQuotesList[myController!.selectedIndex]
                              .backgroundOpicity = value;
                          setState(() {});

                          state(() {});

                          break;
                        case 2:
                          customQuotesList[myController!.selectedIndex]
                              .backgroundCurve = value;
                          setState(() {});
                          state(() {});
                          break;
                      }
                      myValue = value;
                      setState(() {});
                      state(() {});
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  shadowPicker() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.4,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "Shadow",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Divider(
                      thickness: 1,
                      color: Color(0xff63B1FA).withOpacity(0.6),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "X - Axis :",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: customQuotesList[
                                        myController!.selectedIndex]
                                    .xAxisSliderValue,
                                max: 100.0,

                                divisions: 100,
                                // label: customQuotesList[myController!.selectedIndex]
                                //     .blurSliderValue!
                                // .toString(),
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  customQuotesList[myController!.selectedIndex]
                                      .xAxisSliderValue = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // customShadow(
                    //     "Blur Radius",
                    //     customQuotesList[myController!.selectedIndex]
                    //         .blurSliderValue),
                    // customShadow(
                    //     "X - Axis :",
                    //     customQuotesList[myController!.selectedIndex]
                    //         .xAxisSliderValue),
                    // customShadow(
                    //     "BY - Axis : ",
                    //     customQuotesList[myController!.selectedIndex]
                    //         .byAxisSliderValue),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        FastColorPicker(
                          selectedColor:
                              customQuotesList[myController!.selectedIndex]
                                  .backgroundShadow!,
                          onColorSelected: (color) {
                            customQuotesList[myController!.selectedIndex]
                                .backgroundShadow = color;

                            setState(() {});
                            state(() {});
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  shadowBottomSheet() {
    return showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                color: Colors.black,
                height: Get.height * 0.4,
                width: Get.width,
                //  padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Shadow",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Blur Radius :",
                            style: TextStyle(color: Colors.white),
                          ),
                          Divider(color: Color(0xff63B1FA4D)),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: myController!.emojiList.length != 0
                                    ? myController!
                                        .emojiList[myController!.selectedIndex]
                                        .emojiSize!
                                    : 0.0,
                                max: 100,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                onChanged: (double value) {
                                  myController!
                                      .emojiList[myController!.selectedIndex]
                                      .emojiSize = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "X - Axis : :",
                            style: TextStyle(color: Colors.white),
                          ),
                          Divider(color: Color(0xff63B1FA4D)),
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: stickerList.length != 0
                                    ? stickerList[myController!.selectedIndex]
                                        .stickerSize!
                                    : 0.0,
                                max: 360,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                onChanged: (double value) {
                                  stickerList[myController!.selectedIndex]
                                      .stickerSize = value;
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Y - Axis : ",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 1,
                              ),
                              child: Slider(
                                value: fontSizeValue,
                                max: 100,
                                divisions: 100,
                                inactiveColor: Colors.white.withOpacity(0.4),
                                //label: value,
                                onChanged: (double value) {
                                  fontSizeValue = value;
                                  //  myValue = value;
                                  customQuotesList[myController!.selectedIndex]
                                      .textStyle = customQuotesList[
                                          myController!.selectedIndex]
                                      .textStyle!
                                      .copyWith(fontSize: fontSizeValue);

                                  // setState(() {});
                                  setState(() {});
                                  state(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<String> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "_")
        .replaceAll(":", "_");

    final namefile = "screenshot_$time";
    final result = await ImageGallerySaver.saveImage(bytes, name: namefile);

    return result['filePath'];
  }
}

class Cirule extends StatefulWidget {
  int? index;
  String? text;
  String? author;
  TextStyle? textStyle;
  bool? removeEdit;
  Cirule({
    this.index,
    this.text,
    this.author,
    this.textStyle,
    this.removeEdit,
  });

  @override
  State<Cirule> createState() => _CiruleState();
}

class _CiruleState extends State<Cirule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              SizedBox(
                width: Get.width * 0.03,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    //  e.value.text = "";
                    //quotesLis[0] = "";
                    customQuotesList.removeAt(widget.index!);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 0.1,
                        color: widget.text == ""
                            ? Colors.transparent
                            : widget.removeEdit == true
                                ? Colors.transparent
                                : Colors.grey,
                      )),
                  child: Icon(
                    Icons.clear,
                    color: widget.text == ""
                        ? Colors.transparent
                        : widget.removeEdit == true
                            ? Colors.transparent
                            : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
                color: customQuotesList[widget.index!]
                    .backgroundColors!
                    .withOpacity(
                        customQuotesList[widget.index!].backgroundOpicity!),
                borderRadius: BorderRadius.circular(
                    customQuotesList[widget.index!].backgroundCurve!),
                border: Border.all(
                  width: 0.3,
                  color: widget.text == ""
                      ? Colors.transparent
                      : widget.removeEdit == true
                          ? Colors.transparent
                          : Colors.grey,
                )),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RotationTransition(
                  turns: new AlwaysStoppedAnimation(
                      customQuotesList[widget.index!].rotationSliderValue! /
                          360),
                  child: OutlinedText(
                    text: Text(widget.text!,
                        // textAlign: widget.align,
                        maxLines: 4,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        // overflow: textStyle.overflow,
                        style: widget.textStyle),
                    strokes: [
                      OutlinedTextStroke(
                          color: customQuotesList[widget.index!].strokeColors,
                          width: customQuotesList[widget.index!].strokeWidth),
                    ],
                  ),
                ),
                Text(
                  widget.author!,
                  style: widget.textStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Widget circle(
    //     {int? index, String? text, String? author, TextStyle? textStyle}) {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       Row(
    //         children: [
    //           SizedBox(
    //             width: Get.width * 0.03,
    //           ),
    //           InkWell(
    //             onTap: () {
    //               setState(() {
    //                 //  e.value.text = "";
    //                 //quotesLis[0] = "";
    //                 customQuotesList.removeAt(index!);
    //               });
    //             },
    //             child: Container(
    //               decoration: BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   border: Border.all(
    //                     width: 0.1,
    //                     color: text == ""
    //                         ? Colors.transparent
    //                         : removeEdit == true
    //                         ? Colors.transparent
    //                         : Colors.grey,
    //                   )),
    //               child: Icon(
    //                 Icons.clear,
    //                 color: text == ""
    //                     ? Colors.transparent
    //                     : removeEdit == true
    //                     ? Colors.transparent
    //                     : Colors.grey,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       Container(
    //         decoration: BoxDecoration(
    //             color: customQuotesList[index!]
    //                 .backgroundColors!
    //                 .withOpacity(customQuotesList[index].backgroundOpicity!),
    //             borderRadius: BorderRadius.circular(
    //                 customQuotesList[index].backgroundCurve!),
    //             border: Border.all(
    //               width: 0.3,
    //               color: text == ""
    //                   ? Colors.transparent
    //                   : removeEdit == true
    //                   ? Colors.transparent
    //                   : Colors.grey,
    //             )),
    //         padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             RotationTransition(
    //               turns: new AlwaysStoppedAnimation(
    //                   customQuotesList[index].rotationSliderValue! / 360),
    //               child: OutlinedText(
    //                 text: Text(text!,
    //                     textAlign: widget.align,
    //                     maxLines: 4,
    //                     softWrap: false,
    //                     overflow: TextOverflow.fade,
    //                     // overflow: textStyle.overflow,
    //                     style: textStyle),
    //                 strokes: [
    //                   OutlinedTextStroke(
    //                       color: customQuotesList[index].strokeColors,
    //                       width: customQuotesList[index].strokeWidth),
    //                 ],
    //               ),
    //             ),
    //             Text(
    //               author!,
    //               style: textStyle,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
    // }
  }
}

List<String> sticker = [
  "assets/images/Sticker1.jpeg",
  "assets/images/Sticker2.jpeg",
  "assets/images/Sticker3.jpeg",
  "assets/images/Sticker4.jpeg",
  "assets/images/Sticker5.jpeg",
  "assets/images/Sticker6.jpeg",
  "assets/images/Sticker7.jpeg",
];

const SEPIUM = [
  1.3,
  -0.3,
  1.1,
  0.0,
  0.0,
  0.0,
  1.3,
  0.2,
  0.0,
  0.0,
  0.0,
  0.0,
  0.8,
  0.2,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
];
const SEPIA_MATRIX = [
  0.39,
  0.769,
  0.189,
  0.0,
  0.0,
  0.349,
  0.686,
  0.168,
  0.0,
  0.0,
  0.272,
  0.534,
  0.131,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const GREYSCALE_MATRIX = [
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.2126,
  0.7152,
  0.0722,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const VINTAGE_MATRIX = [
  0.9,
  0.5,
  0.1,
  0.0,
  0.0,
  0.3,
  0.8,
  0.1,
  0.0,
  0.0,
  0.2,
  0.3,
  0.5,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const SWEET_MATRIX = [
  1.0,
  0.0,
  0.2,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0
];

const NO_FILTER = [
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
];

const PURRLE = [
  1.0,
  -0.2,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
  -0.1,
  0.0,
  0.0,
  1.2,
  1.0,
  0.1,
  0.0,
  0.0,
  0.0,
  1.7,
  1.0,
  0.0,
];
const YELLOW = [
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  -0.2,
  1.0,
  0.3,
  0.1,
  0.0,
  -0.1,
  0.0,
  1.0,
  0.0,
  0.0,
  0.0,
  0.0,
  0.0,
  1.0,
  0.0,
];
const CYAN = [
  1.0,
  0.0,
  0.0,
  1.9,
  -2.2,
  0.0,
  1.0,
  0.0,
  0.0,
  0.3,
  0.0,
  0.0,
  1.0,
  0.0,
  0.5,
  0.0,
  0.0,
  0.0,
  1.0,
  0.2
];

// ...stickerList.asMap().entries.map((e) => Container(
//       child: GestureDetector(
//         onTap: () {
//           myController!.selectedIndex = e.key;
//           setState(() {});
//         },
//         onHorizontalDragUpdate: (DragUpdateDetails dd) {
//           setState(() {
//             e.value.y = dd.localPosition.dy;
//             e.value.x = dd.localPosition.dx;
//           });
//         },
//         child: Stack(
//           children: [
//             Positioned(
//               top: e.value.y,
//               left: e.value.x,
//               child: Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       setState(() {
//                         //  e.value.text = "";
//                         //quotesLis[0] = "";
//                         stickerList.removeAt(e.key);
//                       });
//                     },
//                     child: Container(
//                       decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             width: 0.1,
//                             color: stickerList[e.key] == ""
//                                 ? Colors.transparent
//                                 : removeEdit == true
//                                     ? Colors.transparent
//                                     : Colors.grey,
//                           )),
//                       child: Icon(
//                         Icons.clear,
//                         color: stickerList[e.key] == ""
//                             ? Colors.transparent
//                             : removeEdit == true
//                                 ? Colors.transparent
//                                 : Colors.grey,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: stickerList[e.key].stickerSize,
//                     // width: 100,
//                     child: Image.asset(stickerList[e.key]
//                         .sticker
//                         .toString()),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     )),
//

//orignal

//second

// ...myController!.emojiList.asMap().entries.map(
//       (e) => Container(
//         child: GestureDetector(
//           onTap: () {
//             myController!.selectedIndex = e.key;
//             setState(() {});
//           },
//           onHorizontalDragUpdate: (DragUpdateDetails dd) {
//             setState(() {
//               e.value.y = dd.localPosition.dy + dd.delta.dy;
//               e.value.x = dd.localPosition.dx + dd.delta.dx;
//             });
//           },
//           child: Stack(
//             children: [
//               Positioned(
//                 top: e.value.y,
//                 left: e.value.x,
//                 child: Stack(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           myController!.emojiList
//                               .removeAt(e.key);
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               width: 0.1,
//                               color: myController!
//                                               .emojiList[
//                                           e.key] ==
//                                       ""
//                                   ? Colors.transparent
//                                   : removeEdit == true
//                                       ? Colors.transparent
//                                       : Colors.grey,
//                             )),
//                         child: Icon(
//                           Icons.clear,
//                           color: myController!
//                                       .emojiList[e.key] ==
//                                   ""
//                               ? Colors.transparent
//                               : removeEdit == true
//                                   ? Colors.transparent
//                                   : Colors.grey,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         myController!.emojiList[e.key]
//                             .emojiController
//                             .toString(),
//                         style: TextStyle(
//                             fontSize: myController!
//                                 .emojiList[e.key]
//                                 .emojiSize),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ),
