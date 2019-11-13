import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:float/constants.dart';
import 'package:float/components/rounded_button.dart';
import 'package:flutter/material.dart';

class Uploader extends StatefulWidget {
  final File file;

  Uploader({@required this.file});

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://float-a5628.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() {
    String filePath = 'images/${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  bool notNull(Object o) => o != null;

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: <Widget>[
              _uploadTask.isComplete ? Text('Is Complete') : null,
              _uploadTask.isPaused
                  ? FlatButton(
                      child: Icon(Icons.play_arrow),
                      onPressed: _uploadTask.resume)
                  : null,
              _uploadTask.isInProgress
                  ? FlatButton(
                      child: Icon(Icons.pause), onPressed: _uploadTask.resume)
                  : null,
              LinearProgressIndicator(
                value: progressPercent,
              ),
              Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
            ].where(notNull).toList(),
          );
        },
      );
    }
    return RoundedButton(
      text: 'Save',
      color: kDarkGreenColor,
      onPressed: _startUpload,
    );
  }
}

//return RoundedButton(
//text: 'Save',
//color: kDarkGreenColor,
//onPressed: () {
////Implement send functionality.
//userController.clear();
//_fireStore.collection('users').add(
//{
//'email': loggedInUser.email,
//'profilePic': _profilePic,
//'supplyHashtags': _hashtagSkills,
//'demandHashtags': _hashtagWishes,
//},
//);
//},
//);
