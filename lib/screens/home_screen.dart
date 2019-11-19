import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:float/screens/create_profile_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseConnection connection = FirebaseConnection();
  bool _isWishes = false;
  FirebaseUser loggedInUser;
  List<Map<String, dynamic>> users = [];
  Map<String, String> imageUrls = Map();
  bool isDataLoaded = false;

  Future<void> _getAndSetLoggedInUser() async {
    loggedInUser = await connection.getCurrentUser();
  }

  Future<void> _getAllUsers() async {
    users = await connection.getAllUsers();
  }

  Future<String> _getAllImageUrls(List<String> fileNames) async {
    String imageUrl;
    for (String fileName in fileNames) {
      imageUrl = await connection.getImageUrl(fileName: fileName);
      imageUrls[fileName] = imageUrl;
    }
  }

  Future<void> _getAllData() async {
    await _getAndSetLoggedInUser();
    await _getAllUsers();
    List<String> fileNames =
        users.map((userMap) => userMap['email'].toString()).toList();
    await _getAllImageUrls(fileNames);
    setState(() {
      isDataLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllData();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      return SpinKitPumpingHeart(
        color: kDarkGreenColor,
        size: 100,
      );
    }
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
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: DataSearch(users: users, imageUrls: imageUrls));
              }),
        ],
        title: Text('Home'),
        backgroundColor: kDarkGreenColor,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Skills',
                style: kTitleSmallTextStyle,
              ),
              CupertinoSwitch(
                value: _isWishes,
                onChanged: (bool value) {
                  setState(() {
                    _isWishes = value;
                  });
                },
              ),
              Text(
                'Wishes',
                style: kTitleSmallTextStyle,
              ),
            ],
          ),
//          StreamBuilder<List<String>>(
//            stream: widget.users,
//            initialData: [],
//            builder: (context, snapshot) => ListView(
//              children: snapshot.data.map(_buildItem).toList(),
//            ),
//          ),
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<Map<String, dynamic>> users;
  final Map<String, String> imageUrls;
  DataSearch({this.users, this.imageUrls});

//  ListTile _buildItem(Map<String, dynamic> userMap) {
//    return ListTile(
//      leading: CircleAvatar(
//        backgroundImage: NetworkImage(imageUrls[userMap['email']]),
//        radius: 60,
//      ),
//      title: Column(
//        children: <Widget>[
//          Text(userMap['email']),
//          Text(userMap['supplyHashtags']),
//        ],
//      ),
//      trailing: IconButton(
//        icon: Icon(Icons.keyboard_arrow_right),
//        onPressed: () {},
//      ),
//    );
//  }

  final cities = [
    'Zurich',
    'Basel',
    'Bern',
    'Lugano',
    'Winterthur',
    'Chiasso',
    'Locarno',
    'Luzern',
    'Genf',
    'Chur',
    'St. Gallen',
    'Davos'
  ];
  final recentCities = ['Genf', 'Chur', 'St. Gallen', 'Davos'];

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
    // show result based on selection
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          Divider(
            height: 10,
          ),
          ProfileItem(imageUrls: imageUrls, users: users, index: index)
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((item) => item.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({
    Key key,
    @required this.imageUrls,
    @required this.users,
    @required this.index,
  }) : super(key: key);

  final Map<String, String> imageUrls;
  final List<Map<String, dynamic>> users;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        backgroundImage: NetworkImage(imageUrls[users[index]['email']]),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            users[index]['email'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            users[index]['supplyHashtags'],
            style: TextStyle(color: Colors.grey, fontSize: 14),
          )
        ],
      ),
      subtitle: Container(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          users[index]['skillRate'].toString() + ' CHF/h',
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
