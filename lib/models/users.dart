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
  String? firstname;
  String? secondname;
  int? companyId;
  int? actived;
  String? email;
  String? type;
  int? emailConfirmed;
  int? deleted;
  int? iscontact;
  String? company;
  String? createdAt;

  DataUsers(
      {this.id,
      this.firstname,
      this.secondname,
      this.companyId,
      this.actived,
      this.email,
      this.type,
      this.emailConfirmed,
      this.deleted,
      this.iscontact,
      this.company,
      this.createdAt});

  DataUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    secondname = json['secondname'];
    companyId = json['company_id'];
    actived = json['actived'];
    email = json['email'];
    type = json['type'];
    emailConfirmed = json['email_confirmed'];
    deleted = json['deleted'];
    iscontact = json['iscontact'];
    company = json['company'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['secondname'] = this.secondname;
    data['company_id'] = this.companyId;
    data['actived'] = this.actived;
    data['email'] = this.email;
    data['type'] = this.type;
    data['email_confirmed'] = this.emailConfirmed;
    data['deleted'] = this.deleted;
    data['iscontact'] = this.iscontact;
    data['company'] = this.company;
    data['created_at'] = this.createdAt;
    return data;
  }
}
