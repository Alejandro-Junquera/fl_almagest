class Product {
  bool? success;
  ProductData? data;
  String? message;

  Product({this.success, this.data, this.message});

  Product.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new ProductData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class ProductData {
  int? id;
  String? articleId;
  String? companyId;
  String? compamyName;
  String? compamyDescription;
  String? price;
  Null? stock;
  String? familyId;
  Null? deleted;

  ProductData(
      {this.id,
      this.articleId,
      this.companyId,
      this.compamyName,
      this.compamyDescription,
      this.price,
      this.stock,
      this.familyId,
      this.deleted});

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    articleId = json['article_id'];
    companyId = json['company_id'];
    compamyName = json['compamy_name'];
    compamyDescription = json['compamy_description'];
    price = json['price'];
    stock = json['stock'];
    familyId = json['family_id'];
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['article_id'] = this.articleId;
    data['company_id'] = this.companyId;
    data['compamy_name'] = this.compamyName;
    data['compamy_description'] = this.compamyDescription;
    data['price'] = this.price;
    data['stock'] = this.stock;
    data['family_id'] = this.familyId;
    data['deleted'] = this.deleted;
    return data;
  }
}
