import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_maker/View/CreateQuotes.dart';
import 'package:quotes_maker/View/HomeScreen.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({Key? key}) : super(key: key);

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/optionScreen.jpg",
                ),
                fit: BoxFit.cover)),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
            ),
            Text(
              "      What do you want to Edit?",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                    color: Colors.black12,
                    onPressed: () {
                      Get.to(CreateQuotes());
                    },
                    child: Text("Photo Edit")),
                SizedBox(
                  width: 30,
                ),
                MaterialButton(
                    color: Colors.black12,
                    onPressed: () {
                      Get.to(HomeScreen());
                    },
                    child: Text("Quotes Edit"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
