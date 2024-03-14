import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'homescreen.dart';

double sofar = 0;

class indi_music1 extends StatefulWidget {
  String songname, songurl, imgname;
  indi_music1(
      {super.key,
        required this.songname,
        required this.songurl,
        required this.imgname});

  @override
  State<indi_music1> createState() =>
      _indiState(songname: songname, songurl: songurl, imgname: imgname);
}

class _indiState extends State<indi_music1> {
  String name = "";
  String songname = "";

  _indiState({
    required songname,
    required songurl,
    required imgname,
  });

  bool isPlaying = true;
  Duration? duration = Duration(minutes: 0, seconds: 0);
  double value = 0;
  bool isLiked = false;

  void initPlayer() async {
    await player.play(UrlSource(widget.songurl)); //use songname variable
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
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return GestureDetector(
        onHorizontalDragEnd: (DragEndDetails details) {
          print(details.velocity.pixelsPerSecond);
          if (details.velocity.pixelsPerSecond.dx < 0.0) {
            player.seek(Duration.zero);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        indi_music1(
                            songname: widget.songname,
                            songurl: widget.songurl,
                            imgname: widget.imgname.trim())));
          }
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
                    child: Image.network(widget.imgname,
                        height: 200.0, fit: BoxFit.cover),
                  )),
              SizedBox(width: 30, height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 0.15 * width, height: 10),
                  InkWell(
                    onTap: () {
                      if (isLiked == false) {
                        isLiked = true;
                        String? u =
                            FirebaseAuth.instance.currentUser!.phoneNumber;
                        print(u);
                        FirebaseFirestore.instance
                            .collection("users")
                            .where("uid", isEqualTo: u)
                            .get()
                            .then((value) =>
                            value.docs.forEach((element) {
                              var s = element["LikedSongs"];
                              s.add(widget.songname);
                              print(element.id);
                              print(s);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(element.id)
                                  .update({"LikedSongs": s});
                              //  FirebaseFirestore.instance.collection('Users').add
                            }));
                      } else {
                        isLiked = false;
                        String? u =
                            FirebaseAuth.instance.currentUser!.phoneNumber;
                        print(u);
                        FirebaseFirestore.instance
                            .collection("users")
                            .where("uid", isEqualTo: u)
                            .get()
                            .then((value) =>
                            value.docs.forEach((element) {
                              var s = element["LikedSongs"];
                              s.remove(widget.songname);
                              print(element.id);
                              print(s);
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(element.id)
                                  .update({"LikedSongs": s});
                            }));
                      }
                    },
                    child: Center(
                      child: Icon(
                          (isLiked == false)
                              ? Icons.favorite_border_outlined
                              : Icons.favorite,
                          color: Color.fromRGBO(193, 211, 238, 1)),
                    ),
                  ),
                  Text(
                    songname,
                    style: TextStyle(color: Colors.white,),
                  ),
                ],
              ),
              Positioned(
                  bottom: 200,
                  left: 105,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            await player
                                .seek(Duration(seconds: new_value.toInt()));
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
                    ],
                  )),
              SizedBox(width: 30, height: 5),
              Positioned(
                  bottom: 150,
                  left: 105,
                  child: Row(
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
                                      isPlaying = true;

                                      print(value);
                                    });
                                  },
                                );

                                print(duration);
                                print(isPlaying);
                              } else if (isPlaying == true) {
                                await player.pause();
                                player.onPositionChanged.listen(
                                      (Duration d) {
                                    setState(() {
                                      value = d.inSeconds.toDouble();

                                      print(value);
                                    });
                                  },
                                );
                                setState(() {
                                  isPlaying = false;
                                });

                                print(duration);
                                print(isPlaying);
                              }
                            },
                            child: Center(
                              child: Icon(
                                  (isPlaying == false)
                                      ? Icons.play_arrow
                                      : Icons.pause,
                                  color: Colors.white70),
                            ),
                          )),
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
                  )),
            ],
          ),
        ));
  }
}
