class Users {
  bool? success;
  List<DataUsers>? data;
  String? message;

  Users({this.success, this.data, this.message});

  Users.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <DataUsers>[];
      json['data'].forEach((v) {
        data!.add(new DataUsers.fromJson(v));
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

class DataUsers {
  int? id;
  String? name;
  String? surname;
  int? cicleId;
  int? actived;
  String? email;
  String? type;
  int? numOfferApplied;
  int? deleted;
  String? emailVerifiedAt;
  String? createdAt;

  DataUsers(
      {this.id,
      this.name,
      this.surname,
      this.cicleId,
      this.actived,
      this.email,
      this.type,
      this.numOfferApplied,
      this.deleted,
      this.emailVerifiedAt,
      this.createdAt});

  DataUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    cicleId = json['cicle_id'];
    actived = json['actived'];
    email = json['email'];
    type = json['type'];
    numOfferApplied = json['num_offer_applied'];
    deleted = json['deleted'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['cicle_id'] = this.cicleId;
    data['actived'] = this.actived;
    data['email'] = this.email;
    data['type'] = this.type;
    data['num_offer_applied'] = this.numOfferApplied;
    data['deleted'] = this.deleted;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}