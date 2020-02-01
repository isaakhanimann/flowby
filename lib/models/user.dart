import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Flowby/constants.dart';

class User {
  String username;
  String uid;
  String bio;
  bool hasSkills;
  bool hasWishes;
  int skillRate;
  int wishRate;
  GeoPoint location;
  int distanceInKm;
  String imageFileName;
  Map<dynamic, dynamic> skills;
  Map<dynamic, dynamic> wishes;
  String skillKeywords;
  String wishKeywords;
  List<SkillOrWish> skillz;
  List<SkillOrWish> wishez;

  List<SkillOrWish> _convertFirebaseToDart({List<dynamic> skillzOrWishez}) {
    if (skillzOrWishez == null) {
      return [];
    }
    List<SkillOrWish> list = [];
    for (var skillOrWish in skillzOrWishez) {
      list.add(SkillOrWish.fromDynamic(skillOrWish));
    }
    return list;
  }

  User(
      {this.username,
      this.uid,
      this.bio,
      this.hasSkills,
      this.hasWishes,
      this.skillRate,
      this.wishRate,
      this.location,
      this.imageFileName,
      this.skills,
      this.wishes});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'] ?? '';
    this.uid = map['uid'] ?? '';
    this.bio = map['bio'] ?? '';
    this.hasSkills = map['hasSkills'] ?? false;
    this.hasWishes = map['hasWishes'] ?? false;
    this.skillRate = map['skillRate'] ?? 20;
    this.wishRate = map['wishRate'] ?? 20;
    this.location = map['location'];
    this.imageFileName = map['imageFileName'] ?? kDefaultProfilePicName;
    this.skillz = _convertFirebaseToDart(skillzOrWishez: map['skillz']);
    this.wishez = _convertFirebaseToDart(skillzOrWishez: map['wishez']);
    this.skillKeywords = _getKeywordString(skillz);
    this.wishKeywords = _getKeywordString(wishez);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'bio': bio,
      'hasSkills': hasSkills,
      'hasWishes': hasWishes,
      'skillRate': skillRate,
      'wishRate': wishRate,
      'imageFileName': imageFileName,
      'skills': skills,
      'wishes': wishes,
    };
  }

  String _getKeywordString(List<SkillOrWish> skillsOrWishes) {
    String result = '';
    if (skillsOrWishes == null || skillsOrWishes.isEmpty) {
      return result;
    }
    for (SkillOrWish skillOrWish in skillsOrWishes) {
      result += skillOrWish.keywords + ' ';
    }
    return result;
  }

  @override
  String toString() {
    String toPrint = '\n{ username: $username, ';
    toPrint += 'uid: $uid, ';
    toPrint += 'bio: $bio, ';
    toPrint += 'hasSkills: $hasSkills, ';
    toPrint += 'hasWishes: $hasWishes, ';
    toPrint += 'skillRate: ${skillRate.toString()}, ';
    toPrint += 'location: ${location.toString()}, ';
    toPrint += 'imageFileName: ${imageFileName.toString()}, ';
    toPrint += 'skills: ${skills.toString()}, ';
    toPrint += 'wishes: ${wishes.toString()}, ';
    toPrint += 'skillKeywords: ${skillKeywords.toString()}, ';
    toPrint += 'wishKeywords: ${wishKeywords.toString()}, ';
    toPrint += 'distanceInKm: ${distanceInKm.toString()} }\n';

    return toPrint;
  }
}

class SkillOrWish {
  String keywords;
  String description;
  String price;

  SkillOrWish({this.keywords, this.description, this.price});

  SkillOrWish.fromDynamic(dynamic skillOrWish) {
    this.keywords = skillOrWish['keywords'];
    this.description = skillOrWish['description'];
    this.price = skillOrWish['price'];
  }

  @override
  String toString() {
    String toPrint = '\n{';
    toPrint += 'keywords: $keywords, ';
    toPrint += 'description: $description, ';
    toPrint += 'price: $price }\n';
    return toPrint;
  }
}
