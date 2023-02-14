import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:quotes_maker/Model/AuthorModel.dart';
import 'package:quotes_maker/Model/categoryModel.dart';
import 'package:quotes_maker/Model/quotationsModel.dart';

class SearchQuotesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CategoriesModel>? categoryData;
  List<AuthorModel>? authorData;
  List<QuotationModel>? quotationData;
  List<QuotationModel>? authorQuotesList;

  var isLoading = true.obs;
  void getAllData() async {
    await Future.wait([
      getAuthorData(),
      getCategoryData(),
      getQuoteData(),
    ]).then((value) {
      isLoading.value = false;
      print("Data");
      //print(authorData[0].author_name);
      print(quotationData![0].quote);
      // print(categoryData[0].category_name);

      print("This is konitob ${quotationData!.length}");
    });
  }

  Future<void> getCategoryData() async {
    await _firestore.collection("categories").get().then((value) {
      categoryData =
          value.docs.map((e) => CategoriesModel.fromJson(e.data())).toList();
    });
  }

  Future<void> getAuthorData() async {
    await _firestore.collection("authors").get().then((value) {
      authorData =
          value.docs.map((e) => AuthorModel.fromJson(e.data())).toList();
    });
  }

  Future<void> getQuoteData() async {
    await _firestore.collection("quotations").get().then((value) {
      quotationData =
          value.docs.map((e) => QuotationModel.fromJson(e.data())).toList();
    });
  }

  Future<void> getAutherQuotes({String? authorName}) async {
    await _firestore
        .collection("quotations")
        .where("author", isEqualTo: authorName)
        .get()
        .then((value) {
      authorQuotesList =
          value.docs.map((e) => QuotationModel.fromJson(e.data())).toList();
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllData();
  }
}
