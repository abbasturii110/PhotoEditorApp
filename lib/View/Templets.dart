import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Templets extends StatefulWidget {
  @override
  _TempletsState createState() => _TempletsState();
}

class _TempletsState extends State<Templets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        body: CustomScrollView(
            // primary: false,
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
                child: Text("Templete"),
              ),
            ),
          ),

          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 7, left: 4, right: 4),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        // margin: EdgeInsets.only(top: 10),
                        height: Get.height * 0.2,
                        child: Image.asset(
                          favoriteList[index],
                          fit: BoxFit.fill,
                        ),
                      )),
                );
              },
              childCount: favoriteList.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0),
          )
        ]));
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
  "assets/images/image2.jpg",
  "assets/images/image4.jpg",
  "assets/images/image5.jpg",
  "assets/images/image7.jpg",
  "assets/images/image2.jpg",
];

class Delegate extends SliverPersistentHeaderDelegate {
  final Color backgroundColor;
  final String _title;

  Delegate(this.backgroundColor, this._title);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          _title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
