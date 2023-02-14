import 'package:flutter/material.dart';
import 'package:get/get.dart';

button({String? text, Function? onPress}) {
  return InkWell(
    onTap: onPress!(),
    child: Container(
      height: Get.width * 0.1,
      width: Get.width,
      child: Material(
        child: Center(
          child: Text(
            text!,
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
