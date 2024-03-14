import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget? getplays() {
  final s = [];
  final p=[];
  FirebaseFirestore.instance.collection("users").where(
      "uid", isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      s.add(element.data());
    });
    return Column(
      children: [
    for(var i in s)
      for(var j in i.keys)
        if(j!="uid")
          Text(j)
    ]);
  }
  );
}