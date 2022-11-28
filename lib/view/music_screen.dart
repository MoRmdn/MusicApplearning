import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/controller/controller.dart';
import 'package:musicapp/model/music_model.dart';
import 'package:musicapp/view/favorite_screen.dart';


class MusicScreen extends GetView<MusicController> {


  MusicController controller = Get.put(MusicController());


  @override
  Widget build(BuildContext context) {
    controller.screenHeight = MediaQuery.of(context).size.height;
    controller.screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child:Scaffold(
          appBar:PreferredSize(
            preferredSize:  Size(0, 60),
            child: GetX<MusicController>(
              builder: (controller) => AppBar(
                title:controller.isSearch.value ? controller.searchField() : Text('Music App'),
                backgroundColor: Colors.indigo,
                elevation: 0.0,
                actions: [
                  IconButton(
                    onPressed: (){

                      controller.isSearch.value = !controller.isSearch.value;
                      controller.isSearch == false? controller.searchItems.clear():null;

                    },
                    icon: Icon(controller.isSearch.value
                        ? Icons.close : Icons.search),
                  ),
                  IconButton(
                      onPressed: ()
                      {

                        Get.to(FavoriteScreen());

                        // controller.showBottomSheet(context);
                      }, icon: Icon(Icons.favorite)
                  )

                ],
              ),
            ),
          ),

          // backgroundColor: Colors.orange,
          body: GetBuilder<MusicController>(
            init: MusicController(),
            builder: (controller) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image:  controller.myImagePath != null
                        ? FileImage(File(controller.myImagePath!))
                        :controller.imagePicked != null ? FileImage(controller.imagePicked!): NetworkImage("https://img.freepik.com/free-vector/vecto"
                        "r-illustration-full-moon-close-up-around-s"
                        "tars_1284-42218.jpg?w=740&t=st=1668278398~ex"
                        "p=1668278998~hmac=c4281d5f6c9b6774a49030654f"
                        "d9d331108b2addadbcbb9762a000be5c0e0116") as ImageProvider,
                  )
              ),
              child: controller.audioPlayer.builderRealtimePlayingInfos(
                  builder: (context, realtimePlayingInfos) {
                    return Column(
                      children: [
                        controller.myImagePath != null
                            ? CircleAvatar(backgroundImage: FileImage(File(controller.myImagePath!)) ,)
                            : CircleAvatar(
                          backgroundImage:controller.imagePicked != null ? FileImage(controller.imagePicked!)  : NetworkImage("https://img.freepik.com/free-vector/vecto"
                              "r-illustration-full-moon-close-up-around-s"
                              "tars_1284-42218.jpg?w=740&t=st=1668278398~ex"
                              "p=1668278998~hmac=c4281d5f6c9b6774a49030654f"
                              "d9d331108b2addadbcbb9762a000be5c0e0116") as ImageProvider,
                        ),
                        ElevatedButton(
                            onPressed: (){
                              controller.PickImage();
                              controller.isSearch.value;
                            },
                            child: Text('Pick Image')),
                        Expanded(child: playlist(realtimePlayingInfos) ),
                        bottomPlayContainer(realtimePlayingInfos),
                      ],
                    );
                  }),
            ),
          ),
      ),

    );
  }


  Widget bottomPlayContainer(RealtimePlayingInfos realtimePlayingInfos)
  {
    return Container(
      height: controller.screenHeight * 0.14,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight:Radius.circular(20.0),)),
      child: Padding(padding: const EdgeInsets.only(left: 10.0,),
        child: Column(
          children: [
            Container(
              height: controller.screenHeight * 0.03,
              child:  Row(
                children: [
                  SizedBox(width: controller.screenWidth * 0.07,),
                  getTimeText(realtimePlayingInfos.currentPosition),
                  SizedBox(width: controller.screenWidth * 0.05,),
                  slider(realtimePlayingInfos.currentPosition,realtimePlayingInfos.duration),
                  SizedBox(width: controller.screenWidth * 0.05,),
                  getTimeText(realtimePlayingInfos.duration),
                  SizedBox(width: controller.screenWidth * 0.1,),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: controller.screenWidth * 0.03,),
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
                    SizedBox(height: controller.screenHeight * 0.005,),

                  ],
                ),
                ),
                SizedBox(width: controller.screenWidth * 0.03,),
                IconButton(
                  icon: Icon(Icons.skip_previous_rounded),
                  iconSize: controller.screenHeight * 0.07,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.indigo,
                  onPressed: () => controller.audioPlayer.previous(),
                ),
                IconButton(
                  icon: Icon(realtimePlayingInfos.isPlaying ?
                  Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
                  iconSize: controller.screenHeight * 0.07,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color:Colors.indigo,
                  onPressed: () => controller.audioPlayer.playOrPause(),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next_rounded),
                  iconSize: controller.screenHeight * 0.07,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  color: Colors.indigo,
                  onPressed: () => controller.audioPlayer.next(),
                ),
                SizedBox(width: controller.screenWidth * 0.1,),
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

      child: GetX<MusicController>(
        builder: (controller) =>ListView.builder(
          itemBuilder: (context,index)=>
              playlistItem(controller.searchItems.isEmpty?
              controller.audioList[index]:controller.searchItems[index]), shrinkWrap: true,
          itemCount:controller.searchItems.isEmpty?
          controller.audioList.length : controller.searchItems.length,
        ),
      )
    );
  }


  Widget playlistItem(MusicModel model) {
    //     items = audioList[index]["audio"] : items = searchItems[index]["audio"];
    return InkWell(
      onTap: () =>   controller.audioPlayer.playlistPlayAtIndex(model.audioId) ,
      splashColor: Colors.transparent,
      // highlightColor: Colors.yellow,
      child: Container(
        height: controller.screenHeight * 0.1,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Text(
                '${model.audioId + 1}',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: controller.screenWidth * 0.04,
              ),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.audioData.metas.title.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: controller.screenHeight * 0.005,
                      ),
                    ],
                  )),
             GetBuilder<MusicController>(builder: (controller) =>  IconButton(
               onPressed: ()async
               {

                   controller.manageFavourites(model.audioId);
               },

               icon: controller.isFavo(model.audioId) ?  Icon(Icons.favorite ,) :Icon(Icons.favorite_border ,) ,
             ),),
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
          height: controller.screenHeight * 0.01,
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
                    controller.audioPlayer.seek(Duration(seconds: 0));
                  } else {
                    controller.audioPlayer.seek(Duration(seconds: value.toInt()));
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
