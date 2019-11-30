import 'package:flutter/material.dart';
import 'package:float/screens/home_screen.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:float/constants.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/screens/chat_screen.dart';

FirebaseConnection connection = FirebaseConnection();

class NavigationScreens extends StatefulWidget {
  static const String id = 'navigation_screen';

  @override
  _NavigationScreensState createState() => _NavigationScreensState();
}

class _NavigationScreensState extends State<NavigationScreens> {
  int _selectedPage = 0;
  final _pageOptions = [HomeScreen(), HomeScreen(), CreateProfileScreen()];
  bool showSearchBar = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pageOptions[_selectedPage]),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: kDarkGreenColor,
        currentIndex: _selectedPage,
        onTap: (int index) async {
          print('index = $index');
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
            default:
              setState(() {
                _selectedPage = 0;
              });
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Profile')),
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
    return StreamBuilder(
      stream: connection.getUsersStream(),
      builder: (context, snapshot) {
        print('snapshot.hasData = ${snapshot.hasData}');
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final List<User> allUsers = [];
        for (var userdoc in snapshot.data.documents) {
          allUsers.add(User.fromMap(map: userdoc.data));
        }

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
    return StreamBuilder(
      stream: connection.getUsersStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text('Nodata'),
          );
        }

        final List<User> allUsers = [];
        for (var userdoc in snapshot.data.documents) {
          allUsers.add(User.fromMap(map: userdoc.data));
        }

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

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.id, arguments: user);
      },
      leading: FutureBuilder(
        future: connection.getImageUrl(fileName: user.email),
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
            user.skillHashtags,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
      subtitle: Container(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          user.skillRate.toString() + ' CHF/h',
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
