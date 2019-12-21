import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_overview_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/services/location.dart';
import 'package:float/widgets/users_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationScreens extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreensState createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  int _selectedPage = 0;
  bool showSearchBar = false;
  List<Widget> _pageOptions;
  List<bool> selections = [true, false];

  void changeSearch(int index) {
    setState(() {
      selections[index] = !selections[index];
      int otherIndex = (index + 1) % 2;
      selections[otherIndex] = !selections[otherIndex];
    });
  }

  Widget _getPage({int pageNumber}) {
    switch (pageNumber) {
      case 0:
        return _pageOptions[0];
      case 1:
        return _pageOptions[0];
      case 2:
        return _pageOptions[1];
      default:
        return _pageOptions[2];
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var loggedInUser = Provider.of<FirebaseUser>(context);
    if (loggedInUser != null) {
      Location.getLastKnownPositionAndUploadIt(userEmail: loggedInUser.email);
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageOptions = [
      HomeScreen(selections: selections, changeSearch: changeSearch),
      ChatOverviewScreen(),
      CreateProfileScreen()
    ];
    return Scaffold(
      body: SafeArea(child: _getPage(pageNumber: _selectedPage)),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: kDarkGreenColor,
        currentIndex: _selectedPage,
        onTap: (int index) async {
          switch (index) {
            case 0:
              setState(() {
                _selectedPage = 0;
              });
              break;
            case 1:
              //search was pressed
              await showSearch(
                  context: context,
                  delegate: DataSearch(isSkillSearch: selections[0]));
              setState(() {
                _selectedPage = 1;
              });
              break;
            case 2:
              setState(() {
                _selectedPage = 2;
              });
              break;
            case 3:
              setState(() {
                _selectedPage = 3;
              });
              break;
            default:
              setState(() {
                _selectedPage = 0;
              });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.search,
            ),
            title: Text('Search'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.conversation_bubble,
            ),
            title: Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person,
            ),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}

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
        stream:
            FirebaseConnection.getSpecifiedUserStream(uid: loggedInUser.email),
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

        return ListView(
          children: suggestedUsers
              .map<Widget>((u) => SuggestionItem(
                    user: u,
                    setQuery: (newQuery) {
                      query = newQuery;
                    },
                    showResults: showResults,
                    isSkillSearch: isSkillSearch,
                  ))
              .toList(),
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
