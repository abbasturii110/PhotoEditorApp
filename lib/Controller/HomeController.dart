import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List ListOfBackgroundImage = [];
  void getAllData() async {
    await Future.wait([
      getBackgroundImage(),
    ]);
  }

  Future<void> getBackgroundImage() async {
    await _firestore
        .collection("backgrounds")
        .get()
        .then((value) => ListOfBackgroundImage = value.docs.toList());
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllData();
  }
}
