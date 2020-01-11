import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/constants.dart';
import 'package:float/models/user.dart';
import 'package:float/services/firebase_cloud_firestore_service.dart';
import 'package:float/widgets/list_of_profiles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSkillSelected = true;
  void switchSearch(var newIsSelected) {
    setState(() {
      isSkillSelected = !isSkillSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    var currentPosition = Provider.of<Position>(context);

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            ButtonThatLooksLikeSearchField(isSkillSelected: isSkillSelected),
            SizedBox(height: 10),
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
            StreamBuilder<List<User>>(
              stream: cloudFirestoreService.getUsersStreamWithDistance(
                  position: currentPosition, uidToExclude: loggedInUser?.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                }
                List<User> users =
                    List.from(snapshot.data); // to convert it editable list
                users.sort((user1, user2) => (user1.distanceInKm ?? 1000)
                    .compareTo(user2.distanceInKm ?? 1000));
                return Expanded(
                    child: ListOfProfiles(
                        users: users, searchSkill: isSkillSelected));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonThatLooksLikeSearchField extends StatelessWidget {
  const ButtonThatLooksLikeSearchField({
    Key key,
    @required this.isSkillSelected,
  }) : super(key: key);

  final bool isSkillSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kLightGrey2,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: ListTile(
        onTap: () {
          showSearch(
              context: context,
              delegate: DataSearch(isSkillSearch: isSkillSelected));
        },
        leading: Icon(
          Icons.search,
          color: Colors.black87,
        ),
        title: Text(
          'Search',
          style: TextStyle(color: Colors.black38, fontSize: 18),
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
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);
    var currentPosition = Provider.of<Position>(context);

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return StreamBuilder<List<User>>(
      stream: cloudFirestoreService.getUsersStreamWithDistance(
          position: currentPosition, uidToExclude: loggedInUser.uid),
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
        return ListOfProfiles(
            users: suggestedUsers, searchSkill: isSkillSearch);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final loggedInUser = Provider.of<FirebaseUser>(context, listen: false);

    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);

    return StreamBuilder<List<User>>(
      stream: cloudFirestoreService.getUsersStream(uid: loggedInUser.uid),
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
