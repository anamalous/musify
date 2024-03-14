import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/musicbutton.dart';
import 'individualsong.dart';

FirebaseFirestore Firestore = FirebaseFirestore.instance;
class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Card(
          child: TextField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search...'),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (name != "" && name != null)
            ? FirebaseFirestore.instance
            .collection('allsongs')
            .where("searchkeywords", arrayContains: name)
            .snapshots()
            : FirebaseFirestore.instance.collection("allsongs").snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot data = snapshot.data!.docs[index];
              return Card(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    musicbutton(width: 0.95*width, height: 0.10*height,
                        imgname: data['img'].toString(),
                        musicname: data['Name'].toString(),
                        artist:data['artist'].toString(),
                        bgcolor: Colors.purpleAccent,
                        Onpressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => indi_music(songname: data['url'].toString(), playlistname: null,)));
                        }),

                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

}