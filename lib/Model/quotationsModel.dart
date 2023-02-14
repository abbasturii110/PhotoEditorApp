class QuotationModel {
  String? author, category, quote_id, quote;
  QuotationModel({this.category, this.author, this.quote, this.quote_id});
  QuotationModel.fromJson(Map<String, dynamic> map) {
    author = map["author"];
    category = map["category"];
    quote = map["quote"];
    quote_id = map["quote_id"];
  }
}
