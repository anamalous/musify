import 'package:cloud_firestore/cloud_firestore.dart';
var imgs={};

Map<dynamic,dynamic> imggetter(String playlistname,String songname){
  FirebaseFirestore.instance.collection("allsongs").where("Name", isEqualTo: songname.trim()).get().
  then((value) => value.docs.forEach((element) {
        imgs[playlistname.trimLeft()]=element['img'];
        }));
  return imgs;
}