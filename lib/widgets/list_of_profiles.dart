import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/helper_functions.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/view_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListOfProfiles extends StatelessWidget {
  const ListOfProfiles({
    Key key,
    @required this.users,
    @required this.searchSkill,
  }) : super(key: key);

  final List<User> users;
  final bool searchSkill;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 90,
      itemBuilder: (context, index) {
        return ProfileItem(
          user: users[index],
          isSkillSearch: searchSkill,
        );
      },
      itemCount: users.length,
    );
  }
}

class ProfileItem extends StatelessWidget {
  final isSkillSearch;
  final User user;

  ProfileItem({@required this.user, this.isSkillSearch = true});

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    final String heroTag = user.uid + 'home';

    return Card(
      elevation: 0,
      color: kLightGrey2,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Center(
        child: ListTile(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ViewProfileScreen(
                      user: user,
                      heroTag: heroTag,
                      loggedInUser: loggedInUser,
                      showSkills: isSkillSearch);
                },
              ),
            );
          },
          leading: Hero(
            tag: heroTag,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/float-a5628.appspot.com/o/images%2F${user.imageFileName}?alt=media'),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                user.username ?? 'Default',
                style: kUsernameTextStyle,
              ),
              if (user.distanceInKm != null)
                Text(
                  user.distanceInKm.toString() + ' km',
                  style: kLocationTextStyle,
                )
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  HelperFunctions.getDotDotDotString(
                      maybeLongString: isSkillSearch
                          ? user.skillHashtags
                          : user.wishHashtags),
                  style: kSkillTextStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  (isSkillSearch ? user.skillRate : user.wishRate).toString() +
                      ' CHF/h',
                  style: kLocationTextStyle,
                ),
              ),
            ],
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
    );
  }
}
