import 'package:finalmusic/components/musicbutton.dart';
import 'package:finalmusic/components/playlistsbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'playlistsongs.dart';
import '../funcanddata/jsonconv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

Stream documentStream = FirebaseFirestore.instance.collection('play1').snapshots();

String curr = "Dusk till Dawn";

final playlists = [
  "Liked",
  "TGIF",
  "Grind time",
  "Late nights"
];
final rec=[
  "Metal",
  "Symphony",
  "Vibes",
  "Retro"
];

final you=[
  "Retro",
  "TGIF",
  "Symphony",
  "Grind time"
];

final songs = [
  "Dusk till Dawn",
  "The Greatest",
  "The Hills",
  "Boyfriend",
  "The Monster",
  "Sunflower",
  "Whats Poppin"

];

class YourLibScreen extends StatefulWidget {
  const YourLibScreen({super.key});


  @override
  State<YourLibScreen> createState() => _YourLState();
}

class _YourLState extends State<YourLibScreen> {

  void changeSong(String a) {
    setState(() {
      curr = a;
    });
  }

  String _searched = "";

  void searchSong(String newval) {
    setState(() {
      _searched = newval;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1000,
        color: Colors.black,
        alignment: Alignment.topCenter,
        child: ListView(
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            children: [
              Text("\n   Good Evening ",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Colors.white)),
              Container(height: 20,),
              Column(
                  children: [
                    for(var i=0;i<playlists.length;i+=2)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for(var j=0;j<2;j++)
                            Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color.fromRGBO(207,176,212,1),width: 2),
                                  borderRadius: BorderRadius.all(Radius.circular(7)),
                                  color: Colors.grey.shade900,
                                ),
                                margin: EdgeInsets.all(4),
                                height: 60,
                                width: 190,
                                child: Container(

                                    child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7)),
                                              image: DecorationImage(
                                                  image: AssetImage("assets/images/"+playlists[i+j]+".jpg"),
                                                  fit: BoxFit.cover,
                                                  opacity: 0.9,
                                                  colorFilter: ColorFilter.mode(
                                                      Colors.grey.shade200,
                                                      BlendMode.multiply)
                                              ),
                                            ),
                                            child: TextButton(
                                                child: Text("",),
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => indi_play(playlistname: playlists[i+j])));
                                                }),
                                          ),
                                          Container(width: 10,),
                                          Text(" "+playlists[i+j],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                        ]))),

                        ],
                      )]
              ),

              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\n   Recently Played",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            color: Colors.white)),
                    Container(height: 20,),
                    SingleChildScrollView(
                        padding: EdgeInsets.all(5),
                        scrollDirection: Axis.horizontal,
                        child:
                        Container(
                            height:200,
                            child:StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
                              .snapshots(),
                          builder: (context, snapshot) {
                            return (snapshot.connectionState == ConnectionState.waiting)
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, index) {
                                QueryDocumentSnapshot d=snapshot.data!.docs[0];
                                if(d!=null) {
                                  var data=jconv(d.data().toString());
                                  return Row(
                                      children: [
                                        for(var j in data.keys)
                                            if(j.toString().contains("uid")==false)
                                              playlistsbutton(orient:"v",width: 140, height: 160, imgname: "", playlistname: j.toString(), bgcolor: Colors.white , Onpressed: "1")

                                      ]);
                                }
                                return Text("");
                              },
                            );
                          },
                        )))]
                  ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\n   For you",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                            color: Colors.white)),
                    Container(height: 20,),
                    SingleChildScrollView(
                        padding: EdgeInsets.all(5),
                        scrollDirection: Axis.horizontal,
                        child:
                        Container(
                            height:200,
                            child:StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                return (snapshot.connectionState == ConnectionState.waiting)
                                    ? Center(child: CircularProgressIndicator())
                                    : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, index) {
                                    QueryDocumentSnapshot d=snapshot.data!.docs[0];
                                    if(d!=null) {
                                      var data=jconv(d.data().toString());
                                      return Row(
                                          children: [
                                            for(var j in data.keys)
                                              if(j.toString().contains("uid")==false)
                                                playlistsbutton(orient:"v",width: 140, height: 160, imgname: "", playlistname: j.toString(), bgcolor: Colors.white , Onpressed: "2")

                                          ]);
                                    }
                                    return Text("");
                                  },
                                );
                              },
                            )))
                  ]),
              Container(height: 100,)
            ])
    );
  }
}