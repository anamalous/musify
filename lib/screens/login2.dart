import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth auth = FirebaseAuth.instance;

final TextEditingController cont1 = TextEditingController();
final TextEditingController cont2 = TextEditingController();

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body:Container(
            width: 500,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg.jpg"),
                    fit: BoxFit.fitWidth,
                    opacity: 0.9,
                    colorFilter: ColorFilter.mode(Colors.grey.shade700, BlendMode.multiply)
                )
            ),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 420,
                  width: 380,
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(color: Colors.grey.shade800,blurRadius: 20)],
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(5))
                  ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  Container(height: 60,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Icon(Icons.music_note,color: Colors.grey.shade500,size: 60,),
                    Text("MusicApp  ",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w400),),
                ]),
                Container(height: 20,),
                Text("SIGN IN",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w200),),
                  Container(height: 30,),
                  /*const Text(
                  "Enter Phone Number\n",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Verdana",
                      fontSize: 25,
                      fontWeight: FontWeight.w300
                  ),
                ),*/
                Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      backgroundBlendMode: BlendMode.hardLight,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    width: 320,
                    height: 53,
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20
                      ),
                      decoration: const InputDecoration(
                        hoverColor: Colors.white,
                        hintText: "   Phone Number",
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 18),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                      ),
                      controller: cont1,
                    )),
                Container(height: 50,),
                ElevatedButton(
                  style: ButtonStyle(
                    shape:MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30)))),
                    fixedSize: MaterialStateProperty.all(Size(280,50)),
                    backgroundColor: MaterialStateProperty.all(Colors.grey.shade800),
                  ),
                    onPressed: () async {
                      await auth.verifyPhoneNumber(
                          timeout: const Duration(seconds: 60),

                          phoneNumber: "+91"+cont1.text,

                          verificationCompleted: (PhoneAuthCredential p) {},

                          verificationFailed: (FirebaseAuthException e) {},

                          codeSent: (String verificationId, int? resendToken) async {
                            //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VerifyScreen(vid:verificationId)));
                            showDialog(
                                context: context, builder: (BuildContext context) =>
                                AlertDialog(
                                    backgroundColor: Colors.black,
                                    title: Text('Enter OTP',style: TextStyle(color: Colors.white),),
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
                                                    keyboardType: TextInputType.number,
                                                    style: TextStyle(color: Colors.white,backgroundColor: Colors.black,),
                                                    controller: cont2
                                                ),),
                                              OutlinedButton(onPressed: () async {
                                                String smsCode = cont2.text;

                                                print(smsCode);
                                                PhoneAuthCredential credential = PhoneAuthProvider
                                                    .credential(
                                                    verificationId: verificationId,
                                                    smsCode: smsCode);

                                                await auth.signInWithCredential(credential)
                                                    .then((value) async{
                                                  if (value.user != null) {
                                                    int c=0;
                                                    FirebaseFirestore f=FirebaseFirestore.instance;
                                                    f.collection("users")
                                                        .get()
                                                        .then((QuerySnapshot querySnapshot) {
                                                      querySnapshot.docs.forEach((doc) {
                                                        print(doc["uid"]);
                                                        if("+91"+cont1.text==doc["uid"])
                                                          c+=1;
                                                      });
                                                      if(c==0)
                                                        f.collection("users").add(
                                                            {"uid": "+91"+cont1.text,"LikedSongs":["Welcome to our app"]});
                                                    });
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context, MaterialPageRoute(
                                                        builder: (
                                                            BuildContext context) => const WelcomeScreen()));
                                                  }
                                                });
                                              },
                                                  child: Text("verify"))
                                            ]
                                        )
                                    )));
                          },
                          codeAutoRetrievalTimeout: (String id) {}
                      );
                    },
                    child: const Text(
                      "SIGN IN",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                      ),))
              ],))]
            )
        ));
  }
}

