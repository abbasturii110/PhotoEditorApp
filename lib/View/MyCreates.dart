import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'InternalImages.dart';

class MyCreate extends StatefulWidget {
  @override
  _MyCreateState createState() => _MyCreateState();
}

class _MyCreateState extends State<MyCreate> {
  // Box<String>? screenshot;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // screenshot = Hive.box("ScreenShot");
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
                child: Text("My Creates"),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SingleChildScrollView(
                child: Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable:
                            Hive.box<String>("ScreenShot").listenable(),
                        builder: (context, Box<String> image, _) {
                          final keys = image.keys.toList();
                          final value = image.values.toList();
                          print('keys length is : ${keys.length}');

                          return Container(
                            //  width: Get.width * 0.6,
                            //height: Get.height * 0.7,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  //  final key = keys[index];
                                  // final val = values[index];
                                  print('keys are : ${keys[index]}');
                                  print('values are : ${value[index]}');
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Container(
                                      height: Get.height * 0.09,
                                      width: Get.width * 0.5,

                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          //color: Colors.yellow,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: ListTile(
                                        onTap: () {
                                          Get.to(() => InternalImages(
                                                file: File(value[index]),
                                              ));
                                        },
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            // color: Colors.grey,
                                            width: Get.width * 0.13,
                                            child: Image.file(
                                              File(value[index]),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          keys[index].toString(),
                                          style: GoogleFonts.getFont(
                                            "Poppins",
                                          ),
                                        ),
                                        subtitle: Text(
                                          "20 - Aug - 2022",
                                          style: GoogleFonts.getFont(
                                            "Poppins",
                                          ),
                                        ),
                                        trailing: Container(
                                          // color: Colors.red,
                                          height: Get.height * 0.1,
                                          width: Get.width * 0.16,
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  Hive.box<String>("ScreenShot")
                                                      .deleteAt(
                                                          image.keyAt(index));

                                                  setState(() {});
                                                },
                                                child: Container(
                                                  child: Image.asset(
                                                    "assets/icons/delete.png",
                                                    height: Get.height * 0.03,
                                                    width: Get.width * 0.08,
                                                  ),
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/icons/Edit.png",
                                                height: Get.height * 0.03,
                                                width: Get.width * 0.08,
                                              ),
                                            ],
                                          ),
                                        ),
                                        //
                                      ),
                                      // width: Get.width * 0.5,
                                    ),
                                  );
                                }),
                          );
                        })
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
