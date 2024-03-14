import 'dart:async';

import 'package:finalmusic/funcanddata/getimg.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

SharedPreferences? prefs;
double sofar=0;
class indi_music extends StatefulWidget {
String playlistname="";
  String songname="";
  String imgname="";
  String songurl="";
  indi_music ({super.key,required songname,required playlistname});

  @override
  State<indi_music> createState() => _indiState(songname:songname,playlistname:playlistname);
}
class _indiState extends State<indi_music> {
  int a=0;
  String playlistname="";
  String songname="";
  String imgname="";
  String songurl="";
  _indiState({required songname,required playlistname});
  bool isPlaying = true;
  Duration? duration = Duration(minutes: 0, seconds: 0);
  double value = 0;

  void initPlayer() async {
    var d=await FirebaseFirestore.instance.collection("allsongs").where("Name",isEqualTo: widget.songname).get().then((value) =>
        value.docs.forEach((element) async{
     print(element['Name']);
      var u=element["url"].toString();
      print(u);
      await player.play(UrlSource(u));
   }));
    prefs=await SharedPreferences.getInstance();
    if (isPlaying == true)
      value = (await player.getCurrentPosition())!.inSeconds + 0.0;
    if (isPlaying == false) value = sofar;
    duration = await player.getDuration();
    print(value);
    if (value == 0.0) await player.resume();
    player.onPositionChanged.listen((Duration d) {
      setState(() {
        value = d.inSeconds.toDouble();
        print(value);
      });
    });
  }
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.songname);
      double height = MediaQuery
          .of(context)
          .size
          .height;
      double width = MediaQuery
          .of(context)
          .size
          .width;
      return GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) async {
            print(details.velocity.pixelsPerSecond);
            if (details.velocity.pixelsPerSecond.dx < 0.0) {
              var q = prefs!.getStringList("queue");
              int? c = await prefs!.getInt("curr");
              if (c! < q!.length - 1)
                prefs!.setInt("curr", c! + 1);
              else
                prefs!.setInt("curr", 0);
              player.seek(Duration.zero);
            }
            if (details.velocity.pixelsPerSecond.dx > 0.0) {
              var q = prefs!.getStringList("queue");
              int? c = await prefs!.getInt("curr");
              if (c! > 0)
                prefs!.setInt("curr", c! - 1);
              else
                prefs!.setInt("curr", q!.length);
              player.seek(Duration.zero);
            }
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) =>
                    indi_music(
                      songname: prefs!.getStringList("queue")![prefs!.getInt(
                          "curr")!], playlistname: "",)));
          },
          child: Scaffold(
            backgroundColor: Colors.black38,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 279,
                    height: 279,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      color: Color.fromRGBO(207, 176, 212, 1),
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                      padding: EdgeInsets.all(20.0),
                      child: Image.network('https://i.pinimg.com/originals/15/ca/79/15ca797e31e129f1c3f6faab22b00e05.jpg', height: 200.0,
                          fit: BoxFit.cover),

                    )
                ),
                Text(songname,
                  style: TextStyle(color: Colors.white, fontSize: 10),),
                SizedBox(width: 30, height: 100),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${(value / 60).floor()}: ${(value % 60).floor()}",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Container(
                      width: 260.0,
                      child: Slider.adaptive(
                        onChangeEnd: (new_value) async {
                          setState(() {
                            value = new_value;
                            print(new_value);
                          });
                          await player.seek(Duration(seconds: new_value
                              .toInt()));
                        },
                        min: 0.0,
                        value: value,
                        max: 214.0,
                        onChanged: (value) {},
                        activeColor: Color.fromRGBO(218, 245, 224, 1),
                      ),
                    ),

                    Text(
                      "${duration!.inMinutes} : ${duration!.inSeconds % 60}",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],),
                SizedBox(width: 30, height: 5),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.white38),
                      ),
                      width: 70.0,
                      height: 70.0,
                      child: InkWell(
                        onTapDown: (details) {
                          player.seek(Duration.zero);
                        },
                        onTapUp: (details) {
                          player.setPlaybackRate(1);
                        },
                        child: Center(
                          child: Icon(
                            Icons.fast_rewind_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.0),
                          color: Colors.black38,
                          border: Border.all(
                              color: Color.fromRGBO(193, 211, 238, 1)),
                        ),
                        width: 60.0,
                        height: 60.0,

                        child: InkWell(
                          onTap: () async {
                            //setting the play function
                            if (isPlaying == false) {
                              await player.resume();
                              player.onPositionChanged.listen(
                                    (Duration d) {
                                  setState(() {
                                    value = d.inSeconds.toDouble();

                                    print(value);
                                  });
                                },
                              );
                              isPlaying = true;
                              print(duration);
                              print(isPlaying);
                            }
                            else if (isPlaying == true) {
                              await player.pause();
                              player.onPositionChanged.listen(
                                    (Duration d) {
                                  setState(() {
                                    value = d.inSeconds.toDouble();
                                    sofar = value;
                                    print(value);
                                  });
                                },
                              );
                              isPlaying = false;
                              print(duration);
                              print(isPlaying);
                            }
                          },
                          child: Center(
                            child: Icon(
                                (isPlaying == false) ? Icons.play_arrow : Icons
                                    .pause, color: Colors.white70),
                          ),
                        )
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.white38),
                      ),
                      width: 70.0,
                      height: 70.0,
                      child: InkWell(
                        onTapDown: (details) {
                          player.setPlaybackRate(2);
                        },
                        onTapUp: (details) {
                          player.setPlaybackRate(1);
                        },
                        child: Center(
                          child: Icon(
                            Icons.fast_forward_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),

          ));

  }
}