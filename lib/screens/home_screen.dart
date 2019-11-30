import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:float/widgets/profile_item.dart';

FirebaseConnection connection = FirebaseConnection();

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
//        SearchSection(),
        StreamBuilder<QuerySnapshot>(
          stream: connection.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<User> allUsers = [];
              for (var userdoc in snapshot.data.documents) {
                allUsers.add(User.fromMap(map: userdoc.data));
              }
              List<Widget> userWidgets = [];
              for (User user in allUsers) {
                final userWidget = Column(
                  children: <Widget>[
                    Divider(
                      height: 10,
                    ),
                    ProfileItem(
                      user: user,
                    )
                  ],
                );
                userWidgets.add(userWidget);
              }
              return Expanded(
                child: ListView(
                  children: userWidgets,
                ),
              );
            }
            return Container(
              color: Colors.white,
              child: SpinKitPumpingHeart(
                color: kDarkGreenColor,
                size: 100,
              ),
            );
          },
        ),
      ],
    );

//      Column(
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              Text(
//                'Skills',
//                style: kTitleSmallTextStyle,
//              ),
//              CupertinoSwitch(
//                value: _isWishes,
//                onChanged: (bool value) {
//                  setState(() {
//                    _isWishes = value;
//                  });
//                },
//              ),
//              Text(
//                'Wishes',
//                style: kTitleSmallTextStyle,
//              ),
//            ],
//          ),
//        ],
//      ),
  }
}
