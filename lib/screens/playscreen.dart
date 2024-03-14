import '../components/musicbutton.dart';
import 'individualsong.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class indi_play extends StatefulWidget {
  indi_play ({super.key});

  @override
  State<indi_play> createState() => _indiplayState();
}
class _indiplayState extends State<indi_play> {


  @override
  Widget build(BuildContext) {

    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    User? u=FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50, width: width,),
              Text("playlists",
                style: TextStyle(color: Colors.black, fontSize: 30,),
                textAlign: TextAlign.center,),
              Container(height: 100,),
              OutlinedButton(
                child:Text("liked"),
                onPressed: (){
                  String? u=FirebaseAuth.instance.currentUser!.phoneNumber;
                  print(u);
                  FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: u).get().then((value)=>value.docs.forEach((element) {
                    var s=element["LikedSongs"];
                    s.add("song3");
                    print(element.id);
                    print(s);
                    FirebaseFirestore.instance.collection("users").doc(element.id).update(
                        {"LikedSongs":s});
                  }));
                },
              ),
              /*Scaffold(
              body: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      QuerySnapshot? d=snapshot.data;
                      if(d!=null) {
                        DocumentSnapshot data = d.docs[index];
                        return Card(
                          child: Row(
                            children: <Widget>[
                              musicbutton(width: 1 * width,
                                  height: 0.07 * height,
                                  imgname: "xyz.jpg",
                                  musicname: "YMCA",
                                  artist: "Village People",
                                  bgcolor: Color.fromRGBO(0, 0, 0, 0.5),
                                    Onpressed: () {}),
                          SizedBox(height: 2, width: width,)
                    ]));
                  }
                    else{
                      return Text("no data");
                      }}
                  );
                },
              ),)
              /*Row(
                  children:[
                    musicbutton(width: 1 * width,
                        height: 0.07 * height,
                        imgname: "xyz.jpg",
                        musicname: "YMCA",
                        artist: "Village People",
                        bgcolor: Color.fromRGBO(0, 0, 0, 0.5),
                        Onpressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => indi_music(songname: "YMCA")));
                        }),
                    SizedBox(height: 2, width: width,),
                  ])*/*/
            ],
          ),
        )
    );
  }
}
