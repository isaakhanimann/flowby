import 'dart:io';

class User {
  String email;
  File profilePic;
  List<String> supplyHashtags;
  List<String> demandHashtags;

  User({this.email, this.profilePic, this.supplyHashtags, this.demandHashtags});
}
