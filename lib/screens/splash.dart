import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'login2.dart';
import 'homescreen.dart';


class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _splashyState();
}

class _splashyState extends State<SplashScreen> {
  bool animate = false;

  @override
  void initState(){
    super.initState();
    Timer(const Duration(seconds:3),() {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) =>
          FirebaseAuth.instance.currentUser==null?LoginScreen():WelcomeScreen()));
    }
    );
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.black,
        body : Stack(
          children: [
            Center(
              child:Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/sound-wave-wave.gif"),
                      fit: BoxFit.cover),
                ),
              ),

            ),
            Positioned(
              top:600,
              left: 110,
              child: Text(
                'Tune in,Turn Up ',
                style: TextStyle(fontSize: 25,color: Colors.white60,fontFamily: "Roboto"),
              ),
            ),

          ],
        )
    );
  }
}