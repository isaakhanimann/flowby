import 'package:float/models/user.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final searchSkill;
  final User user;

  ProfileItem({@required this.user, this.searchSkill = true});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.id, arguments: user);
      },
      leading: FutureBuilder(
        future: FirebaseConnection.getImageUrl(fileName: user.email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CircleAvatar(
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
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            searchSkill ? user.skillHashtags : user.wishHashtags,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
      subtitle: Container(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          (searchSkill ? user.skillRate : user.wishRate).toString() + ' CHF/h',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.keyboard_arrow_right),
        onPressed: () {},
      ),
    );
  }
}
