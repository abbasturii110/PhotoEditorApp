import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "cancel",
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "Unlock all",
                    style: TextStyle(color: Colors.white54),
                  )
                ],
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Text(
                "Themes",
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Container(
                height: Get.height * 0.7,
                child: GridView.builder(
                    itemCount: image.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                        childAspectRatio: 0.7,
                        crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          String images = image[index];
                          //  Get.to(() => CreateQuotes(quotes: images));
                        },
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.asset(
                              image[index],
                              fit: BoxFit.cover,
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
    );
  }
}

List image = [
  "assets/images/image1.jpg",
  "assets/images/image2.jpg",
  "assets/images/image3.jpg",
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image6.jpg",
  "assets/images/image7.jpg"
];
