import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Flowby/constants.dart';

class User {
  String username;
  String uid;
  String bio;
  bool isHidden;
  GeoPoint location;
  int distanceInKm;
  String imageUrl;
  String skillKeywords;
  String wishKeywords;
  List<SkillOrWish> skills = [];
  List<SkillOrWish> wishes = [];
  int totalNumberOfUnreadMessages = 0;

  User(
      {this.username,
      this.uid,
      this.bio,
      this.isHidden,
      this.skills,
      this.wishes,
      this.location,
      this.imageUrl,
      this.totalNumberOfUnreadMessages});

  User.fromMap({Map<String, dynamic> map}) {
    this.username = map['username'] ?? '';
    this.uid = map['uid'] ?? '';
    this.bio = map['bio'] ?? '';
    this.isHidden = map['isHidden'] ?? false;
    try {
      this.location = map['location'];
    } catch (e) {
      this.location = _convertLocationToGeopoint(location: map['location']);
    }
    this.imageUrl = map['imageUrl'] ?? kDefaultProfilePicUrl;
    this.skills = _convertFirebaseToDart(skillsOrWishes: map['skills']);
    this.wishes = _convertFirebaseToDart(skillsOrWishes: map['wishes']);
    this.skillKeywords = _getKeywordString(skills);
    this.wishKeywords = _getKeywordString(wishes);
    try {
      this.totalNumberOfUnreadMessages =
          map['totalNumberOfUnreadMessages'] ?? 0;
    } catch (e) {
      this.totalNumberOfUnreadMessages = 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'bio': bio,
      'isHidden': isHidden,
      'location': location,
      'imageUrl': imageUrl ?? kDefaultProfilePicUrl,
      'skills': skills?.map((SkillOrWish s) => s.toMap())?.toList(),
      'wishes': wishes?.map((SkillOrWish w) => w.toMap())?.toList(),
      'totalNumberOfUnreadMessages': totalNumberOfUnreadMessages,
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
    toPrint += 'isHidden: $isHidden, ';
    toPrint += 'location: ${location.toString()}, ';
    toPrint += 'imageUrl: $imageUrl, ';
    toPrint += 'skills: ${skills.toString()}, ';
    toPrint += 'wishes: ${wishes.toString()}, ';
    toPrint += 'skillKeywords: ${skillKeywords.toString()}, ';
    toPrint += 'wishKeywords: ${wishKeywords.toString()}, ';
    toPrint +=
        'totalNumberOfUnreadMessages: ${totalNumberOfUnreadMessages.toString()}, ';
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
