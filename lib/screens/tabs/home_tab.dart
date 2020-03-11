import 'package:Flowby/constants.dart';
import 'package:Flowby/screens/view_profile_screen.dart';
import 'package:Flowby/services/firebase_cloud_firestore_service.dart';
import 'package:Flowby/widgets/centered_loading_indicator.dart';
import 'package:Flowby/widgets/profile_picture.dart';
import 'package:Flowby/widgets/tab_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:Flowby/models/user.dart';
import 'package:Flowby/models/announcement.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Future<List<Announcement>> anouncementsFuture;

  @override
  void initState() {
    super.initState();
    final cloudFirestoreService =
        Provider.of<FirebaseCloudFirestoreService>(context, listen: false);
    anouncementsFuture = cloudFirestoreService.getAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TabHeader(),
              Expanded(
                  child: FutureBuilder(
                      future: anouncementsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return CenteredLoadingIndicator();
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Container(
                              color: Colors.red,
                              child: const Text('Something went wrong'),
                            ),
                          );
                        }
                        List<Announcement> announcements = List.from(
                            snapshot.data); // to convert it to editable list
                        return ListView.builder(
                            itemCount: announcements.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                  child: Text(
                                    'Announcements',
                                    style: kTabTitleTextStyle,
                                    textAlign: TextAlign.start,
                                  ),
                                );
                              }
                              return AnnouncementItem(
                                announcement: announcements[index - 1],
                              );
                            });
                      }))
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _addAnnouncement,
              child: Icon(Feather.plus),
            ),
          )
        ],
      ),
    );
  }

  _addAnnouncement() async {
    //create and upload an announcement here
  }
}

class AnnouncementItem extends StatelessWidget {
  final Announcement announcement;

  AnnouncementItem({@required this.announcement});

  @override
  Widget build(BuildContext context) {
    final heroTag = announcement.uid + 'announcements';
    final loggedInUser = Provider.of<User>(context, listen: false);

    return Card(
      elevation: 0,
      color: kCardBackgroundColor,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Center(
        child: ListTile(
          onTap: () {
            User announcementUser = User(
                uid: announcement.uid,
                username: announcement.username,
                imageFileName: announcement.imageFileName,
                imageVersionNumber: announcement.imageVersionNumber);
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<void>(
                builder: (context) {
                  return ViewProfileScreen(
                      user: announcementUser,
                      heroTag: heroTag,
                      loggedInUser: loggedInUser);
                },
              ),
            );
          },
          leading: ProfilePicture(
            imageFileName: announcement.imageFileName,
            imageVersionNumber: announcement.imageVersionNumber,
            radius: 30,
            heroTag: heroTag,
          ),
          title: Text(
            announcement.username,
            overflow: TextOverflow.ellipsis,
            style: kUsernameTextStyle,
          ),
          subtitle: Text(
            announcement.text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: kChatLastMessageTextStyle,
          ),
          trailing: Icon(Feather.chevron_right),
        ),
      ),
    );
  }
}
