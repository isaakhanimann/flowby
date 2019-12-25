import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/stream_list_users.dart';
import 'package:float/widgets/users_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static const String id = 'home_screen';
  final Function switchSearch;
  final isSkillSelected;
  HomeScreen({@required this.isSkillSelected, @required this.switchSearch});

  @override
  Widget build(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    //to do the search call:
//    showSearch(
//        context: context,
//        delegate: DataSearch(isSkillSearch: isSkillSelected));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            CupertinoSegmentedControl(
              borderColor: kDarkGreenColor,
              pressedColor: kLightGreenColor,
              selectedColor: kDarkGreenColor,
              groupValue: isSkillSelected,
              onValueChanged: switchSearch,
              children: <bool, Widget>{
                true: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: Text('Skills', style: TextStyle(fontSize: 18)),
                ),
                false: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  child: Text('Wishes', style: TextStyle(fontSize: 18)),
                ),
              },
            ),
            SizedBox(height: 10),
            StreamBuilder(
              stream: FirebaseConnection.getUserStream(uid: loggedInUser.email),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(color: Colors.white);
                }
                User user = snapshot.data;
                return StreamListUsers(
                  userStream: FirebaseConnection.getUsersStreamWithDistance(
                      loggedInUser: user),
                  searchSkill: isSkillSelected,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Search Functionality

class DataSearch extends SearchDelegate<String> {
  bool isSkillSearch;
  DataSearch({@required this.isSkillSearch});

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
    var loggedInUser = Provider.of<FirebaseUser>(context);
    return StreamBuilder(
        stream: FirebaseConnection.getUserStream(uid: loggedInUser.email),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(color: Colors.white);
          }
          User user = snapshot.data;
          return StreamBuilder<List<User>>(
            stream: FirebaseConnection.getUsersStreamWithDistance(
                loggedInUser: user),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('Nodata'),
                );
              }

              final List<User> allUsers = snapshot.data;
              List<User> suggestedUsers;

              if (isSkillSearch) {
                suggestedUsers = allUsers
                    .where((u) => u.skillHashtags
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              } else {
                suggestedUsers = allUsers
                    .where((u) => u.wishHashtags
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                    .toList();
              }
              return UsersListView(
                  users: suggestedUsers, searchSkill: isSkillSearch);
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var loggedInUser = Provider.of<FirebaseUser>(context);

    return StreamBuilder<List<User>>(
      stream: FirebaseConnection.getUsersStream(loggedInUser: loggedInUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final List<User> allUsers = snapshot.data;

        List<User> suggestedUsers;

        if (isSkillSearch) {
          suggestedUsers = allUsers
              .where((u) => u.skillHashtags
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        } else {
          suggestedUsers = allUsers
              .where((u) => u.wishHashtags
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
              .toList();
        }

        return ListView.builder(
          itemCount: suggestedUsers.length,
          itemExtent: 50,
          itemBuilder: (context, index) {
            return SuggestionItem(
              user: suggestedUsers[index],
              setQuery: (newQuery) {
                query = newQuery;
              },
              showResults: showResults,
              isSkillSearch: isSkillSearch,
            );
          },
        );
      },
    );
  }
}

class SuggestionItem extends StatelessWidget {
  final User user;
  final Function setQuery;
  final Function showResults;
  final bool isSkillSearch;

  SuggestionItem(
      {@required this.user,
      @required this.setQuery,
      @required this.showResults,
      @required this.isSkillSearch});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setQuery(isSkillSearch ? user.skillHashtags : user.wishHashtags);
        showResults(context);
      },
      leading: Icon(Icons.insert_emoticon),
      title: Text(
        isSkillSearch ? user.skillHashtags : user.wishHashtags,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
