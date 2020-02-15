import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Flowby/constants.dart';
import 'package:flutter/cupertino.dart';

class User {
  String username;
  String uid;
  String bio;
  bool hasSkills;
  bool hasWishes;
  GeoPoint location;
  int distanceInKm;
  String imageFileName;
  String skillKeywords;
  String wishKeywords;
  List<SkillOrWish> skills;
  List<SkillOrWish> wishes;

  List<SkillOrWish> _convertFirebaseToDart({List<dynamic> skillsOrWishes}) {
    if (skillsOrWishes == null) {
      return [];
    }
    List<SkillOrWish> list = [];
    for (var skillOrWish in skillsOrWishes) {
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
      this.skills,
      this.wishes,
      this.location,
      this.imageFileName});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'] ?? '';
    this.uid = map['uid'] ?? '';
    this.bio = map['bio'] ?? '';
    this.hasSkills = map['hasSkills'] ?? false;
    this.hasWishes = map['hasWishes'] ?? false;
    this.location = map['location'];
    this.imageFileName = map['imageFileName'] ?? kDefaultProfilePicName;
    this.skills = _convertFirebaseToDart(skillsOrWishes: map['skills']);
    this.wishes = _convertFirebaseToDart(skillsOrWishes: map['wishes']);
    this.skillKeywords = _getKeywordString(skills);
    this.wishKeywords = _getKeywordString(wishes);
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'bio': bio,
      'hasSkills': hasSkills,
      'hasWishes': hasWishes,
      'imageFileName': imageFileName ?? 'default-profile-pic.jpg',
      'skills': skills?.map((SkillOrWish s) => s.toMap())?.toList(),
      'wishes': wishes?.map((SkillOrWish w) => w.toMap())?.toList()
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

  updateSkillKeywordsAtIndex({int index, String text}) {
    skills[index].keywords = text;
  }

  updateSkillDescriptionAtIndex({int index, String text}) {
    skills[index].description = text;
  }

  updateSkillPriceAtIndex({int index, String text}) {
    skills[index].price = text;
  }

  addEmptySkill() {
    skills.add(SkillOrWish(keywords: '', description: '', price: ''));
  }

  static List<SkillOrWish> controllersToListOfSkillsOrWishes(
      {List<TextEditingController> keywordsControllers,
      List<TextEditingController> descriptionControllers,
      List<TextEditingController> priceControllers}) {
    List<SkillOrWish> list = [];
    for (int i = 0; i < keywordsControllers.length; i++) {
      String keywords = keywordsControllers[i].text;
      String description = descriptionControllers[i].text;
      String price = priceControllers[i].text;
      if (keywords != null && keywords.isNotEmpty) {
        list.add(SkillOrWish(
            keywords: keywords, description: description, price: price));
      }
    }
    return list;
  }

  @override
  String toString() {
    String toPrint = '\n{ username: $username, ';
    toPrint += 'uid: $uid, ';
    toPrint += 'bio: $bio, ';
    toPrint += 'hasSkills: $hasSkills, ';
    toPrint += 'hasWishes: $hasWishes, ';
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

  Map<String, String> toMap() {
    Map<String, String> map = Map();
    map['keywords'] = keywords;
    map['description'] = description;
    map['price'] = price;
    return map;
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
