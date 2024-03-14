import 'individualsong.dart';
import 'package:flutter/material.dart';
import 'library.dart';
import 'package:audioplayers/audioplayers.dart';
import 'accountscreen.dart';
import 'searchbutton.dart';
import 'playlistsscreen.dart';

final player = AudioPlayer();

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcState();
}

class _WelcState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String a="none";
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          TabBarView(
            physics: ScrollPhysics(
                parent: NeverScrollableScrollPhysics()
            ),
            controller: _tabController,
            children:[
              YourLibScreen(),
              CloudFirestoreSearch(),
              Playlists()
            ],
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.end,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  color: Colors.grey.shade900,
                  child: OutlinedButton(
                    onPressed: (){Navigator.push(context,MaterialPageRoute(builder: (BuildContext context)=>indi_music(songname: "", playlistname: null,)));},
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Image(image: AssetImage("assets/images/Dusk till Dawn.png"),height: 70,),
                        Container(width:260, child:Text("     $curr",style: TextStyle(color: Colors.white))),
                        IconButton(alignment:Alignment.centerRight,onPressed: ()async{await player.pause();}, icon: const Icon(Icons.pause,size: 30),color: Colors.white,)
                      ],
                    ),
                  ),),
                Container(height: 3,)
              ]),
        ]),
        backgroundColor: Colors.grey.shade900,
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "Play",
              icon: Icon(Icons.music_note),
            ),
            Tab(
              text: "Search",
              icon: Icon(Icons.search),
            ),
            Tab(
              text: "Playlists",
              icon: Icon(Icons.library_books_outlined),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: IconButton(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 27,0, 0),
            icon: Icon(
              Icons.settings,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext contest) => YouScreen()));}
        )
    );
  }
}
