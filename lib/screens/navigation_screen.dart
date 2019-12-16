import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/screens/chat_overview_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/widgets/profile_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationScreens extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreensState createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  int _selectedPage = 0;
  final _pageOptions = [
    HomeScreen(),
    ChatOverviewScreen(),
    CreateProfileScreen()
  ];

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

  bool showSearchBar = false;

  @override
  Widget build(BuildContext context) {
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
              await showSearch(context: context, delegate: DataSearch());
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
    return StreamBuilder<List<User>>(
      stream: FirebaseConnection.getUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final List<User> allUsers = snapshot.data;

        final List<User> suggestedUsers = allUsers
            .where(
                (u) => u.skillHashtags.toString().toLowerCase().contains(query))
            .toList();

        return ListView(
          children: suggestedUsers
              .map<Widget>(
                (user) => Column(
                  children: <Widget>[
                    Divider(
                      height: 10,
                    ),
                    ProfileItem(
                      user: user,
                    )
                  ],
                ),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<User>>(
      stream: FirebaseConnection.getUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final List<User> allUsers = snapshot.data;

        final List<User> suggestedUsers = allUsers
            .where(
                (u) => u.skillHashtags.toString().toLowerCase().contains(query))
            .toList();

        return ListView(
          children: suggestedUsers
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
  }
}

class SuggestionItem extends StatelessWidget {
  final User user;
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
        setQuery(user.skillHashtags);
        showResults(context);
      },
      leading: Icon(Icons.insert_emoticon),
      title: Text(
        user.skillHashtags,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
