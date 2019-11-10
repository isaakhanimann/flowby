import 'dart:io';

class User {
  File profilePic;
  String username;
  String email;
  String password;
  List<String> supplyHashtags;
  List<String> demandHashtags;

  User(
      {this.profilePic,
      this.username,
      this.email,
      this.password,
      this.supplyHashtags,
      this.demandHashtags});
}
