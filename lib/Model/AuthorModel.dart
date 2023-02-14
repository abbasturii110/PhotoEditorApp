class AuthorModel {
  String? author_id, author_image, author_name;
  AuthorModel({
    this.author_id,
    this.author_image,
    this.author_name,
  });
  AuthorModel.fromJson(Map<String, dynamic> map) {
    author_id = map["author_id"];
    author_image = map["author_image"];
    author_name = map["author_name"];
  }
}
