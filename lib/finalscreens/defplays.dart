import 'package:finalmusic/components/musicbutton.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'individualsong.dart';

class indi_play2 extends StatelessWidget {
  String playlistname ;
  indi_play2 ({Key ? key,required this.playlistname,} ):  super (key :key);

  @override
  Widget build(BuildContext context) {
    print(playlistname);
    double h= MediaQuery
        .of(context)
        .size
        .height;
    double w = MediaQuery
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
              Row(
                  children:[
                    Container(width:300,child:Text("     "+playlistname,style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w300),),),
                    ]),
              Container(height: 10,),
              Container(
                height: h*0.65,
                width: w,
                child:StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("playlists")
                      .where("name",isEqualTo:playlistname.trim())
                      .snapshots(),
                  builder: (context, snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot d=snapshot.data!.docs[index];
                        if(d!=null) {print(playlistname);
                          return Column(
                              children: [
                                for(var j in d["songs"])
                                  musicbutton(width: w*0.9, height: 80, imgname: "", musicname: j, artist: "", bgcolor: Colors.grey.shade800, Onpressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => indi_music(songname: j, playlistname: "",)));
                                    })
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
