import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void queueify(String playlistname,String songname) async{
  print(playlistname);
  SharedPreferences prefs= await SharedPreferences.getInstance();
  String? u=FirebaseAuth.instance.currentUser!.phoneNumber;
  FirebaseFirestore.instance.collection("users").where("uid",isEqualTo: u).get().then((value)=>value.docs.forEach((element) {
    print(element["uid"]);
    prefs.setStringList("queue", List<String>.from(element[playlistname.trim()]));
    //prefs.setInt("curr", value)
  }
    ));
}