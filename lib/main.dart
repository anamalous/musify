import 'package:flutter/material.dart';
import 'finalscreens/mainscreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainScreen());
}