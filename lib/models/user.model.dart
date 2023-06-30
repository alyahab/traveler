
class UserModel {
  String? id;
  String? email;
  String? fullname;
  String? phone;

  UserModel({required this.id, required this.email, required this.fullname, required this.phone});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullname = json['fullname'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
      'phone': phone,
    };
  }
}