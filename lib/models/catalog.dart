class Catalog {
  bool? success;
  List<CatalogData>? data;
  String? message;

  Catalog({this.success, this.data, this.message});

  Catalog.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <CatalogData>[];
      json['data'].forEach((v) {
        data!.add(new CatalogData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CatalogData {
  int? id;
  int? articleId;
  int? companyId;
  String? compamyName;
  String? compamyDescription;
  String? price;
  int? stock;
  int? familyId;
  int? deleted;

  CatalogData(
      {this.id,
      this.articleId,
      this.companyId,
      this.compamyName,
      this.compamyDescription,
      this.price,
      this.stock,
      this.familyId,
      this.deleted});

  CatalogData.fromJson(Map<String, dynamic> json) {
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
