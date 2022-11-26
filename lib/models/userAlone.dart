class UserAlonePlus {
  bool? success;
  UserAlone? data;
  String? message;

  UserAlonePlus({this.success, this.data, this.message});

  UserAlonePlus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new UserAlone.fromJson(json['data']) : null;
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

class UserAlone {
  int? id;
  String? name;
  String? surname;
  int? cicleId;
  int? actived;
  String? email;
  int? numOfferApplied;
  String? type;
  int? deleted;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UserAlone(
      {this.id,
      this.name,
      this.surname,
      this.cicleId,
      this.actived,
      this.email,
      this.numOfferApplied,
      this.type,
      this.deleted,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  UserAlone.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    cicleId = json['cicle_id'];
    actived = json['actived'];
    email = json['email'];
    numOfferApplied = json['num_offer_applied'];
    type = json['type'];
    deleted = json['deleted'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['cicle_id'] = this.cicleId;
    data['actived'] = this.actived;
    data['email'] = this.email;
    data['num_offer_applied'] = this.numOfferApplied;
    data['type'] = this.type;
    data['deleted'] = this.deleted;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
