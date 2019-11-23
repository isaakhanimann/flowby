import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:float/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseConnection connection = FirebaseConnection();

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, CreateProfileScreen.id);
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  //showSearch would return the result passed back from close
                  await showSearch(context: context, delegate: DataSearch());
                }),
          ],
          title: Text('Home'),
          backgroundColor: kDarkGreenColor,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: connection.getUsersStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final users = snapshot.data.documents;
              List<Widget> userWidgets = [];
              for (var user in users) {
                final userWidget = Column(
                  children: <Widget>[
                    Divider(
                      height: 10,
                    ),
                    ProfileItem(
                      imageUrl:
                          connection.getImageUrl(fileName: user.data['email']),
                      user: user.data,
                      onPress: () {
                        Navigator.pushNamed(context, ChatScreen.id,
                            arguments: user.data['email']);
                      },
                    )
                  ],
                );
                userWidgets.add(userWidget);
              }
              return ListView(
                children: userWidgets,
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
        )

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
        );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: connection.getUsersStream(),
      builder: (context, snapshot) {
        print('snapshot.hasData = ${snapshot.hasData}');
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final userList = snapshot.data.documents;
        final results = userList
            .where((u) => u.data['supplyHashtags']
                .toString()
                .toLowerCase()
                .contains(query))
            .toList();

        return ListView(
          children: results
              .map<Widget>(
                (u) => Column(
                  children: <Widget>[
                    Divider(
                      height: 10,
                    ),
                    ProfileItem(
                      imageUrl:
                          connection.getImageUrl(fileName: u.data['email']),
                      user: u.data,
                      onPress: () {
                        Navigator.pushNamed(context, ChatScreen.id,
                            arguments: u.data['email']);
                      },
                    )
                  ],
                ),
              )
              .toList(),
        );
      },
    );
    //query contains the hashtag that we need for filtering out the right users
    //filter out the users that have the right hashtags
//    final querymatchingUsers = usersStream.da
//        .where((u) => u['supplyHashtags'].toLowerCase().contains(query))
//        .toList();
//    // show result based on selection
//    return ListView.builder(
//      itemCount: querymatchingUsers.length,
//      itemBuilder: (context, index) => Column(
//        children: <Widget>[
//          Divider(
//            height: 10,
//          ),
//          ProfileItem(
//            imageUrl: imageUrls[querymatchingUsers[index]['email']],
//            user: querymatchingUsers[index],
//            onPress: () {
//              Navigator.pushNamed(context, ChatScreen.id,
//                  arguments: querymatchingUsers[index]['email']);
//            },
//          )
//        ],
//      ),
//    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: connection.getUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final userList = snapshot.data.documents;
        final results = userList
            .where((u) => u.data['supplyHashtags']
                .toString()
                .toLowerCase()
                .contains(query))
            .toList();

        return ListView(
          children: results
              .map<Widget>((u) => SuggestionItem(
                    user: u,
                    setQuery: (newQuery) {
                      query = newQuery;
                    },
                    showResults: showResults,
                  ))
              .toList(),
        );
      },
    );

//    final listHashtags = users.map((u) => u['supplyHashtags']).toList();
//    final suggestionList = query.isEmpty
//        ? listHashtags
//        : listHashtags.where((a) => a.toLowerCase().contains(query)).toList();
//    return ListView.builder(
//      itemBuilder: (context, index) => ListTile(
//        onTap: () {
//          query = suggestionList[index];
//          showResults(context);
//        },
//        leading: Icon(Icons.location_city),
//        title: RichText(
//          text: TextSpan(
//              text: suggestionList[index].substring(0, query.length),
//              style:
//                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//              children: [
//                TextSpan(
//                    text: suggestionList[index].substring(query.length),
//                    style: TextStyle(color: Colors.grey))
//              ]),
//        ),
//      ),
//      itemCount: suggestionList.length,
//    );
  }
}

class SuggestionItem extends StatelessWidget {
  final user;
  final Function setQuery;
  final Function showResults;
  SuggestionItem(
      {@required this.user,
      @required this.setQuery,
      @required this.showResults});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        print('This is called');
        setQuery(user['supplyHashtags']);
        print("setquery was called");
        showResults(context);
        print('showResults was called');
      },
      leading: Icon(Icons.insert_emoticon),
      title: Text(
        user['supplyHashtags'],
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    Key key,
    @required this.imageUrl,
    @required this.user,
    @required this.onPress,
  }) : super(key: key);

  final Future<String> imageUrl;
  final Map<String, dynamic> user;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: FutureBuilder(
        future: imageUrl,
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
            user['email'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            user['supplyHashtags'],
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
      subtitle: Container(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          user['skillRate'].toString() + ' CHF/h',
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
