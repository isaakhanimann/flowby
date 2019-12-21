import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final isSkillSearch;
  final User user;

  ProfileItem({@required this.user, this.isSkillSearch = true});

  @override
  Widget build(BuildContext context) {
    print('profileUser = ${user.toString()}');
    return Card(
      elevation: 0,
      color: kLightGrey2,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, ChatScreen.id, arguments: user);
        },
        leading: FutureBuilder(
          future: FirebaseConnection.getImageUrl(fileName: user.email),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(snapshot.data),
              );
            }
            return CircleAvatar(
              backgroundColor: Colors.grey,
            );
          },
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
                isSkillSearch ? user.skillHashtags : user.wishHashtags,
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
        trailing: IconButton(
          icon: Icon(Icons.keyboard_arrow_right),
          onPressed: () {},
        ),
      ),
    );
  }
}
