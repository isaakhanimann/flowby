import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Flowby/constants.dart';
import 'package:Flowby/models/role.dart';

class User {
  String username;
  String uid;
  String bio;
  Role role;
  bool isHidden;
  GeoPoint location;
  int distanceInKm;
  String imageFileName = kDefaultProfilePicName;
  int imageVersionNumber = 1;
  String skillKeywords;
  String wishKeywords;
  List<SkillOrWish> skills = [];
  List<SkillOrWish> wishes = [];

  User(
      {this.username,
      this.uid,
      this.bio,
      this.role,
      this.isHidden,
      this.skills,
      this.wishes,
      this.location,
      this.imageFileName,
      this.imageVersionNumber});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'] ?? '';
    this.uid = map['uid'] ?? '';
    this.bio = map['bio'] ?? '';
    this.role = convertStringToRole(roleString: map['role']);
    this.isHidden = map['isHidden'] ?? false;
    try {
      this.location = map['location'];
    } catch (e) {
      this.location = _convertLocationToGeopoint(location: map['location']);
    }
    this.imageFileName = map['imageFileName'] ?? kDefaultProfilePicName;
    try {
      this.imageVersionNumber = map['imageVersionNumber'].round();
    } catch (e) {
      //could not convert double to int (because its infinity or NaN)
      this.imageVersionNumber = 1;
    }
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
      'role': convertRoleToString(role: role),
      'isHidden': isHidden,
      'location': location,
      'imageFileName': imageFileName ?? 'default-profile-pic.jpg',
      'imageVersionNumber': imageVersionNumber ?? 1,
      'skills': skills?.map((SkillOrWish s) => s.toMap())?.toList(),
      'wishes': wishes?.map((SkillOrWish w) => w.toMap())?.toList(),
    };
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
    if (skills == null) {
      skills = [];
    }
    skills.add(SkillOrWish(keywords: '', description: '', price: ''));
  }

  deleteSkillAtIndex({int index}) {
    skills.removeAt(index);
  }

  updateWishKeywordsAtIndex({int index, String text}) {
    wishes[index].keywords = text;
  }

  updateWishDescriptionAtIndex({int index, String text}) {
    wishes[index].description = text;
  }

  updateWishPriceAtIndex({int index, String text}) {
    wishes[index].price = text;
  }

  addEmptyWish() {
    if (wishes == null) {
      wishes = [];
    }
    wishes.add(SkillOrWish(keywords: '', description: '', price: ''));
  }

  deleteWishAtIndex({int index}) {
    wishes.removeAt(index);
  }

  @override
  String toString() {
    String toPrint = '\n{ username: $username, ';
    toPrint += 'uid: $uid, ';
    toPrint += 'bio: $bio, ';
    toPrint += 'role: ${convertRoleToString(role: role)}, ';
    toPrint += 'isHidden: $isHidden, ';
    toPrint += 'location: ${location.toString()}, ';
    toPrint += 'imageFileName: ${imageFileName.toString()}, ';
    toPrint += 'imageVersionNumber: ${imageVersionNumber.toString()}, ';
    toPrint += 'skills: ${skills.toString()}, ';
    toPrint += 'wishes: ${wishes.toString()}, ';
    toPrint += 'skillKeywords: ${skillKeywords.toString()}, ';
    toPrint += 'wishKeywords: ${wishKeywords.toString()}, ';
    toPrint += 'distanceInKm: ${distanceInKm.toString()} }\n';

    return toPrint;
  }

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

  GeoPoint _convertLocationToGeopoint({dynamic location}) {
    try {
      if (location == null || location == []) {
        return null;
      }
      double latitude = location['_latitude'];
      double longitude = location['_longitude'];
      GeoPoint point = GeoPoint(latitude, longitude);
      return point;
    } catch (e) {
      print('Could not convert location to geopoint');
      print(e);
      return null;
    }
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
