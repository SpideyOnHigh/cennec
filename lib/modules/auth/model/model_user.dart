// import 'package:equatable/equatable.dart';
//
// /// A model class for user.
// /// The ModelUser class is a Dart class that extends Equatable and has a toJson() method that returns a
// /// Map<String, dynamic> and a fromJson() method that takes a Map<String, dynamic> as a parameter
// //ignore: must_be_immutable
// class ModelUser extends Equatable {
//   int? id;
//   String? message;
//   String? username;
//   String? mobile;
//   String? name;
//   String? companyName;
//   String? password;
//   String? confirmPassword;
//   String? email;
//   bool? agreeTerms;
//   dynamic status;
//   String? statusText;
//   int? type;
//   String? typeText;
//   String? token;
//
//   ModelUser(
//       {this.id,
//       this.email,
//       this.agreeTerms,
//       this.confirmPassword,
//       this.password,
//       this.message,
//       this.username,
//       this.mobile,
//       this.name,
//       this.companyName,
//       this.status,
//       this.statusText,
//       this.type,
//       this.typeText,
//       this.token});
//
//   ModelUser.fromJson(Map<String, dynamic> json) {
//     password = json['mc_number'];
//     password = json['dot_number'];
//     password = json['password'];
//     agreeTerms = json['agreeTerms'];
//     email = json['email'];
//     confirmPassword = json['confirmPassword'];
//     message = json['message'];
//     id = json['id'];
//     username = json['username'];
//     mobile = json['mobile'];
//     name = json['name'];
//     companyName = json['company_name'];
//     status = json['status'];
//     statusText = json['status_text'];
//     type = json['type'];
//     typeText = json['type_text'];
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['password'] = password;
//     data['confirmPassword'] = confirmPassword;
//     data['email'] = email;
//     data['agreeTerms'] = agreeTerms;
//     data['message'] = message;
//     data['username'] = username;
//     data['mobile'] = mobile;
//     data['name'] = name;
//     data['company_name'] = companyName;
//     data['status'] = status;
//     data['status_text'] = statusText;
//     data['type'] = type;
//     data['type_text'] = typeText;
//     data['token'] = token;
//     return data;
//   }
//
//   @override
//   List<Object?> get props =>
//       [id, message, username, mobile, name, companyName, status, statusText, type, typeText, token];
// }
