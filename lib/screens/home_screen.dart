import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:float/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:float/widgets/rounded_button.dart';
import 'package:float/widgets/hashtag_bubble.dart';
import 'package:float/services/firebase_connection.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:float/screens/create_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseConnection connection = FirebaseConnection();
  bool _isWishes = false;

  FirebaseUser loggedInUser;

  Future<void> _getAndSetLoggedInUser() async {
    loggedInUser = await connection.getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _getAndSetLoggedInUser();
  }

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
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              }),
        ],
        title: Text('Home'),
        backgroundColor: kDarkGreenColor,
      ),
      body: Row(
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
    );
  }
}

class DataSearch extends SearchDelegate<String> {
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
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: Colors.red,
        child: Center(
          child: Text(query),
        ),
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
