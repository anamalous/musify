import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login2.dart';

String mode="light";
bool modeVal = false;

class YouScreen extends StatefulWidget {
  const YouScreen({super.key});

  @override
  State<YouScreen> createState() => _YouState();
}

class _YouState extends State<YouScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
            width: 1000,
            padding: EdgeInsets.fromLTRB(0,30,20,0),
            height: 1000,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("\n         Settings  \n",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w100,
                        fontSize: 30,
                        color: Colors.white)),
                TextButton(onPressed: (){FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(
                    builder: (
                        BuildContext context) => const LoginScreen()));},
                    child: Text("logout",style: TextStyle(color: Colors.white),))

              ],
            )));
  }
}
