import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/profile_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
        StreamBuilder<List<User>>(
          stream: FirebaseConnection.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<User> users = snapshot.data;
              List<Widget> userWidgets = [];
              for (User user in users) {
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
