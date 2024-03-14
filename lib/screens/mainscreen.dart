import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]
    );
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:SplashScreen()
    );
  }
}
