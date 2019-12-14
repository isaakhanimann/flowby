class User {
  String username;
  String email;
  String skillHashtags;
  String wishHashtags;
  int skillRate;
  int wishRate;

  User(
      {this.username,
      this.email,
      this.skillHashtags,
      this.wishHashtags,
      this.skillRate,
      this.wishRate});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'];
    this.email = map['email'];
    this.skillHashtags = map['skillHashtags'];
    this.wishHashtags = map['wishHashtags'];
    this.skillRate = map['skillRate'];
    this.wishRate = map['wishRate'];
  }
}
