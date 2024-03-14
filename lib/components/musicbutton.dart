import 'package:flutter/material.dart';

class musicbutton extends StatelessWidget
{
  double width,height;
  String imgname,musicname,artist;
  Color bgcolor;
  final Function() Onpressed;
  musicbutton ({Key?key,
    required this.width,
    required this.height,
    required this.imgname,
    required this.musicname,
    required this.artist,
    required this.bgcolor,
    required this.Onpressed}) : super(key:key);
  @override
  Widget build(BuildContext){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      height: height,
      width: width,
      color: bgcolor,
      child:ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor,
          padding: EdgeInsets.all(3),// Background color
        ),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /*Image.asset("assets/images/"+imgname, height:0.90*height,width:0.14*width,
                fit: BoxFit.cover),*/
            SizedBox(height: 0.50*height,width:25),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 0.15*height,width:35),
                  Text(musicname,
                    style: TextStyle(color: Colors.white,fontSize:18),
                  ),
                  SizedBox(height: 0.02*height,width:35),
                  Text("    "+artist,
                    style: TextStyle(color: Colors.white70,fontSize:10),
                  ),
                ],
              ),
            ),

          ],
        ),
        onPressed:Onpressed,
      ),
    );

  }


}