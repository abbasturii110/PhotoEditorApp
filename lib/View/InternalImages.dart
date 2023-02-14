import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternalImages extends StatelessWidget {
  File? file;
  InternalImages({this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        child: Image.file(
          file!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
