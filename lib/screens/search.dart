import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore Firestore = FirebaseFirestore.instance;
class CloudFirestoreSearch extends StatefulWidget {
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";

  @override
  Widget build(BuildContext context) {
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
            .where("searchKeywords", arrayContains: name)
            .snapshots()
            : FirebaseFirestore.instance.collection('allsongs').snapshots(),
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
                      /*Image.network(
                      data['Name'],
                      width: 150,
                      height: 100,
                      fit: BoxFit.fill,
                    )*/
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        data['Name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Text("");
            },
          );
        },
      ),
    );
  }

}