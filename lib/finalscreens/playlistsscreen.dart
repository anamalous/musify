import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../funcanddata/jsonconv.dart';
import '../components/playlistsbutton.dart';
import '../funcanddata/getimg.dart';

var cont2=TextEditingController();

class Playlists extends StatefulWidget{
  const Playlists({super.key});
  @override
  State<Playlists> createState() => PlayState();
}
class PlayState extends State<Playlists> {
  @override
  Widget build(BuildContext context) {
    double h= MediaQuery
        .of(context)
        .size
        .height;
    double w= MediaQuery
        .of(context)
        .size
        .width;
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
          Text("   Playslists",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w300),),
          Container(height: 30,),
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
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot d=snapshot.data!.docs[0];
                  if(d!=null) {
                    var data=jconv(d.data().toString());
                    for(var i in data.keys){
                      if(i.toString().contains("uid")==false) {
                        imggetter(i,data[i][1]);
                      }}
                    return Column(
                        children: [
                          for(var j in data.keys)
                            if(j.toString().contains("uid")==false)
                              playlistsbutton(orient: "h",width: w*0.95, height: 80, imgname: imgs[j.toString().trimLeft()], playlistname: j.toString(), bgcolor: Colors.white , Onpressed: "1")

                        ]);
                  }
                  return Text("");
                },
              );
            },
          ),),
          OutlinedButton(child: Text("create playlist",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w100),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey.shade900)),
              onPressed: (){
                showDialog(
                    context: context, builder: (BuildContext context) =>
                AlertDialog(
                    backgroundColor: Colors.black,
                    title: Text("Create playlist",style: TextStyle(color: Colors.white),),
                    content: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration:BoxDecoration(
                                    border: Border.all(color: Colors.white)),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "  Name",
                                    hintStyle: TextStyle(color: Colors.grey,fontSize: 20)
                                  ),
                                    style: TextStyle(color: Colors.white,backgroundColor: Colors.black,),
                                    controller: cont2
                                ),),
                              OutlinedButton(onPressed: () async {
                                Navigator.pop(context);
                                String? u=FirebaseAuth.instance.currentUser!.phoneNumber;
                                FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: u).get().then((value)=>value.docs.forEach((element) {
                                  FirebaseFirestore.instance.collection("users").doc(element.id).update(
                                      {cont2.text:["Welcome to our app","ymca"]});
                                }));
                              },
                                  child: Text("Create"))
                            ]
                        )
                    )));
              })
      ]))
    );
  }
}