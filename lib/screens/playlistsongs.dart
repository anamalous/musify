import 'package:finalmusic/components/musicbutton.dart';
import 'package:finalmusic/components/playlistsbutton.dart';
import 'package:finalmusic/funcanddata/jsonconv.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../funcanddata/queueadd.dart';
import 'individualsong.dart';

class indi_play extends StatelessWidget {
  var s=[];
  String playlistname ;
  indi_play ({Key ? key,required this.playlistname,} ):  super (key :key);

  @override
  Widget build(BuildContext context) {
    double h= MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
        .of(context)
        .size
        .width;
    User? u=FirebaseAuth.instance.currentUser;
    print(s);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: h,
          padding: EdgeInsets.fromLTRB(10, 60, 0, 0),
          color: Colors.black,
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children:[
            Row(
          children:[
            Container(width:300,child:Text("     "+playlistname,style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w300),),),
          OutlinedButton(onPressed: (){


            String? u=FirebaseAuth.instance.currentUser!.phoneNumber;
            FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: u).get()
                .then((value)=>value.docs.forEach((element) {
              var s=element[playlistname];
              s.add("song3");
              FirebaseFirestore.instance.collection("users").doc(element.id).update(
                  {playlistname:s});
            }));



          }, child: Text("add song"))]),
          Container(height: 10,),
          Container(
            height: h*0.65,
            width: w,
            child:StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
                    .snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot d=snapshot.data!.docs[0];
                      if(d!=null) {
                        return Column(
                            children: [
                                  for(var j in d[playlistname.trim()])
                                    musicbutton(width: w*0.9, height: 80, imgname: "", musicname: j, artist: "", bgcolor: Colors.grey.shade800, Onpressed: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => indi_music(songname: "", imgname: "")));
                                      queueify(playlistname,j);})
                            ]);
                      }
                      return Text("");
                    },
                  );
                },
              ),
          )],
          ),
        )
    );
  }
}
