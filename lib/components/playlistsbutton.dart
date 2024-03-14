import 'package:flutter/material.dart';
import '../finalscreens/playsongs.dart';
import '../finalscreens/defplays.dart';
class playlistsbutton extends StatelessWidget
{
  double width,height;
  String imgname,playlistname;
  Color bgcolor;
  String orient;
  final String Onpressed;
  playlistsbutton ({Key?key,
    required this.orient,
    required this.width,
    required this.height,
    required this.imgname,
    required this.playlistname,
    required this.bgcolor,
    required this.Onpressed}) : super(key:key);
  @override
  Widget build(BuildContext context){
    return Container(
        margin: EdgeInsets.all(4),
        //padding: EdgeInsets.all(3),
        height: height+32,
        width:width,
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border.all(color: Color.fromRGBO(193,211,238,1),width: 2),
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            alignment: Alignment.centerLeft,
            child: orient=="v"?Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Image(
                  image:NetworkImage(Uri.parse(imgname).toString()),
                  height: width,
                  width: width,
                  fit: BoxFit.cover,),
                TextButton(
                    child: Text(" $playlistname",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                            color: Color.fromRGBO(247, 244, 235,1))),
                    onPressed: () async{
                      if(Onpressed.contains("2"))
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => indi_play2(playlistname: playlistname.trim())));
                      if(Onpressed.contains("1"))
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => indi_play(playlistname: playlistname)));
                      //int res= await player.play(sound);
                    }),
              ],
            ):Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Container(width: 10,),
                Image(
                  image:NetworkImage(Uri.parse(imgname).toString()),
                  height: height,
                  width: height,
                  fit: BoxFit.cover,),
                TextButton(
                    child: Text(" $playlistname",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                            color: Color.fromRGBO(247, 244, 235,1))),
                    onPressed: (){
      if(Onpressed.contains("1"))
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => indi_play(playlistname: playlistname.trim())));
                    }),
              ],
            )
        )
        );

  }


}