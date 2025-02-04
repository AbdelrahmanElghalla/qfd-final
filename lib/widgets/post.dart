import 'package:firebase_database/firebase_database.dart';
class Post{

  static const KEY = "key";
  static const DATE = "date";
  static const TITLE = "title";
  static const BODY = "body";
  
  int date;
  String key;
  String title;
  String body;
  List<PostComment> comments;

  Post(this.date, this.title, this.body);

//  String get key  => _key;
//  String get date  => _date;
//  String get title  => _title;
//  String get body  => _body;



  Post.fromSnapshot(DataSnapshot snap):
        this.key = snap.key,
        this.body = snap.value[BODY],
        this.date = snap.value[DATE],
        this.title = snap.value[TITLE];

  Map toMap(){
    return {BODY: body, TITLE: title, DATE: date, KEY: key};
  }
}


class PostComment{
  String key;
String userName;
String comment;
String date;

  PostComment.fromSnapshot(DataSnapshot snap):
        this.key = snap.key,
        this.userName = snap.value['userName'],
        this.date = snap.value['date'],
        this.comment = snap.value['comment'];

  Map toMap(){
    return {'key':key, 'userName': userName, 'date':date, 'comment':comment};
  }

}