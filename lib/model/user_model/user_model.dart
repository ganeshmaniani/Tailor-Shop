class UserDetail {
  User? user;
  bool? apiSuccess;
  String? apiMessage;

  UserDetail({this.user, this.apiSuccess, this.apiMessage});

  UserDetail.fromJson(Map<String, dynamic> json) {
    user = json['users'] != null ? User.fromJson(json['users']) : null;
    apiSuccess = json['Api_success'];
    apiMessage = json['Api_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['users'] = user!.toJson();
    }
    data['Api_success'] = apiSuccess;
    data['Api_message'] = apiMessage;
    return data;
  }
}

class User {
  int? id;
  int? shopId;
  String? shopName;
  String? firstName;
  String? email;
  String? password;
  String? mobileNumber;
  String? plainPassword;
  String? profileImage;

  User(
      {this.id,
      this.shopId,
      this.shopName,
      this.firstName,
      this.email,
      this.password,
      this.mobileNumber,
      this.plainPassword,
      this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    shopName = json['shop_name'];
    firstName = json['first_name'];
    email = json['email'];
    password = json['password'];
    mobileNumber = json['mobile_number'];
    plainPassword = json['plain_password'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['shop_id'] = shopId;
    data['shop_name'] = shopName;
    data['first_name'] = firstName;
    data['email'] = email;
    data['password'] = password;
    data['mobile_number'] = mobileNumber;
    data['plain_password'] = plainPassword;
    data['profile_image'] = profileImage;
    return data;
  }
}
