import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/controller.dart';

class FavoriteScreen extends StatefulWidget {
   FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  double screenHeight = 0;

  double screenWidth = 0;
  final MusicController controller = Get.find<MusicController>();
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();


  @override
  void initState() {
    super.initState();
    setupPlayList();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    setupPlayList();
    super.dispose();
  }
  void setupPlayList() async {
    await audioPlayer.open(Playlist(audios: controller.favList.map((e)
    => e.audioData).toList() ),
        showNotification: true, autoStart: false,loopMode: LoopMode.playlist);
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:Text('Music App'),
          backgroundColor: Colors.orange,
          elevation: 0.0,
        ),
        backgroundColor: Colors.orange,
        body:controller.favList.isEmpty ? Center(child: Text('Empty'),): audioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimePlayingInfos) {
              return Column(
                children: [
                  Expanded(child: playlist(realtimePlayingInfos) ),
                  bottomPlayContainer(realtimePlayingInfos),
                ],
              );
            }),
      ),
    );
  }

  Widget buildFavItems() {
    return Padding(padding: EdgeInsets.all(10));
  }

  Widget bottomPlayContainer(RealtimePlayingInfos realtimePlayingInfos)
  {
    return Container(
      height: screenHeight * 0.14,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight:Radius.circular(20.0),)),
      child: Padding(padding: const EdgeInsets.only(left: 10.0,),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.03,
              child:  Row(
                children: [
                  SizedBox(width: screenWidth * 0.07,),
                  getTimeText(realtimePlayingInfos.currentPosition),
                  SizedBox(width: screenWidth * 0.05,),
                  slider(realtimePlayingInfos.currentPosition,realtimePlayingInfos.duration),
                  SizedBox(width: screenWidth * 0.05,),
                  getTimeText(realtimePlayingInfos.duration),
                  SizedBox(width: screenWidth * 0.1,),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: screenWidth * 0.03,),
                Expanded(child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // to get the music title
                    Text(realtimePlayingInfos.current!.audio.audio.metas.title.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.indigo
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005,),

                  ],
                ),
                ),
                SizedBox(width: screenWidth * 0.03,),
                IconButton(
                  icon: Icon(Icons.skip_previous_rounded),
                  iconSize: screenHeight * 0.07,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.indigo,
                  onPressed: () =>audioPlayer.previous(),
                ),
                IconButton(
                  icon: Icon(realtimePlayingInfos.isPlaying ?
                  Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                  iconSize: screenHeight * 0.07,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color:Colors.indigo,
                  onPressed: () => audioPlayer.playOrPause(),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next_rounded),
                  iconSize: screenHeight * 0.07,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.indigo,
                  onPressed: () =>audioPlayer.next(),
                ),
                SizedBox(width: screenWidth * 0.1,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget playlist(RealtimePlayingInfos realtimePlayingInfos)
  // this widget is the ListView widget
  {
    return Container(
      // this is the container that Control the listView
      height: screenHeight * 0.35,
      alignment: Alignment.bottomLeft,
      child: ListView.builder(
        itemBuilder: (context,index) {
          return playlistItem(index);
        }, shrinkWrap: true,
        itemCount:  controller.favList.length ,
      ),
    );
  }

  Widget playlistItem(int index) {
    return InkWell(
      onTap: () =>   audioPlayer.playlistPlayAtIndex(index) ,
      splashColor: Colors.transparent,
      highlightColor: Colors.yellow,
      child: Container(
        height: screenHeight * 0.1,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Text(
                '${index+1}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: screenWidth * 0.04,
              ),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.favList[index].audioData.metas.title.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.005,
                      ),
                    ],
                  )),
              IconButton(
                onPressed: ()
                {

                  // controller.manageFavourites(index);

                },
                icon:  Icon(Icons.favorite ,)  ,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget slider(Duration currentPosition, Duration duration) {
    return Stack(
      children: [
        Container(
          height: screenHeight * 0.01,
        ),
        SliderTheme(
            data: SliderThemeData(
                thumbColor: Colors.white,
                activeTrackColor: Color(0xff10d541),
                inactiveTrackColor: Colors.grey[800],
                overlayColor: Colors.transparent),
            child: Slider.adaptive(
                value: currentPosition.inSeconds.toDouble(),
                max: duration.inSeconds.toDouble() + 3,
                min: -3,
                onChanged: (value) {
                  if (value <= 0) {
                    audioPlayer.seek(Duration(seconds: 0));
                  } else {
                    audioPlayer.seek(Duration(seconds: value.toInt()));
                  }
                })),
      ],
    );
  }

  Widget getTimeText(Duration seconds) {
    return Text(
      transformString(seconds.inSeconds),
      style: TextStyle(
        color: Colors.white,
      ),
    );
  }

  String transformString(int seconds) {
    String minuteString =
        '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';

    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString'; // Returns a string with the format mm:ss
  }
}
 