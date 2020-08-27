import 'package:firebase_database/firebase_database.dart';
import 'package:qfd/widgets/post.dart';
import 'package:qfd/screens/edit_post.dart';
import 'package:flutter/material.dart';
import '../services/PostService.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostView extends StatefulWidget {
  final Post post;

  PostView(this.post);

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {


  
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String nodeName ;
  List<PostComment> commentsList = <PostComment>[];

  @override
  void initState() {
    super.initState();
    nodeName ='posts/'+widget.post.key+'/comments';
    _database.reference().child(nodeName).onChildAdded.listen(_childAdded);
    _database.reference().child(nodeName).onChildRemoved.listen(_childRemoves);
    _database.reference().child(nodeName).onChildChanged.listen(_childChanged);

  }



  _childAdded(Event event) {
    setState(() {
      commentsList.add(PostComment.fromSnapshot(event.snapshot));
    });
  }

  void _childRemoves(Event event) {
    var deletedPost = commentsList.singleWhere((post){
      return post.key == event.snapshot.key;
    });

    setState(() {
      commentsList.removeAt(commentsList.indexOf(deletedPost));
    });
  }

  void _childChanged(Event event) {
    var changedPost = commentsList.singleWhere((post){
      return post.key == event.snapshot.key;
    });

    setState(() {
      commentsList[commentsList.indexOf(changedPost)] = PostComment.fromSnapshot(event.snapshot);
    });
  }

  
  addPostComment(){
    FirebaseDatabase database = FirebaseDatabase.instance;
    nodeName ='posts/'+widget.post.key+'/comments';
    database.reference().child(nodeName).push().set({'user':'Username','comment':controller.text});
    controller.clear();
  }

TextEditingController controller=new TextEditingController ();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.post.date)),
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ),),
                IconButton(icon: Icon(Icons.delete),
                  onPressed: (){
                    PostService postService = PostService(widget.post.toMap());
                    postService.deletePost();
                    Navigator.pop(context);

                  },),
                IconButton(icon: Icon(Icons.edit),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EditPost(widget.post)));
                  },),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.post.body),
            ),
            Container(
              height: 500,
              child: ListView(
                children:List.generate(commentsList.length, (index) => 
                Container(
                  height: 50,
                  width: 100,
                child: Text(commentsList[index].comment),),
                ),
              ),
            ),
         Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
                height: 50,
        width: MediaQuery.of(context).size.width-60,
        
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter your answer for the qustion'
                ),
              ),
            ),
            InkWell(
              onTap: (){
addPostComment();
              },
              child: Container(
                height: 30,
        width:50,
                child: Text('Send')),
            )
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}
