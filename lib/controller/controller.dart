import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicapp/model/music_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MusicController extends GetxController with GetSingleTickerProviderStateMixin{

  List<MusicModel> audioList = [
    MusicModel(audioData:
    Audio('assets/Akon.mp3', metas: Metas(title: 'Akon',)),
        audioId: 0
    ),
    MusicModel(
      audioData:
      Audio('assets/bondok.mp3',
          metas: Metas(
              title: 'Bondok',
              image: MetasImage.network('https://raw.githubusercontent.com/florent37/Flutter-AssetsAudioPlayer/master/medias/notification_android.png')
          )),
      audioId: 1,

    ),


  ];
  List<String> myList = [];

  List<MusicModel> favList = [];
  @override
  void onInit() async{
    super.onInit();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    setupPlayList();
    LoadedImage();
    getSongs();
  }

  bool isFavourites = false;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  File? image;
  ImagePicker imagePicker = ImagePicker();
  var isSearch = false.obs;
  String isFav = 'isFav';
  String? token;
  late bool liked = false;

  Widget searchField(){
    return TextFormField(
      onChanged: (value){
        searchEngine(value);
        update();
      },
      decoration: InputDecoration(
        hintText: 'Search with name',
      ),
    );
  }
  bool isAnimated = false;
  bool showPlay = true;
  bool showPause = false;
  double screenHeight = 0;
  double screenWidth = 0;
  RxList searchItems = [].obs;
  File? imagePicked;
  String? myImagePath;
  void searchEngine(String searchItem){
    //searchItems = audioList.values;
      searchItems.value = audioList.where((element) => element.audioData.metas.title!.toLowerCase().contains(searchItem.toLowerCase())).toList();
      // searchItems = audioList.where((element) => element.audioData.metas.title!.toLowerCase().startsWith(searchItem.toLowerCase())).toList();
    update();
  }

  late AnimationController animationController;
  void setupPlayList() async {
    await audioPlayer.open(Playlist(audios: audioList.map((e) => e.audioData).toList() as List<Audio> ),
        showNotification: true, autoStart: false,loopMode: LoopMode.playlist,);
  }
  void  manageFavourites(int musicId)async{
    var existingIndex = favList.indexWhere((element) => element.audioId == musicId);
    if(existingIndex >=0){
      await favList.removeAt(existingIndex);
      SharedPreferences prefs =await SharedPreferences.getInstance();
      myList = favList.map((e) => e.audioData.metas.title.toString()).toList();
      prefs.setStringList(isFav, myList);
       prefs.setInt(isFav, musicId);

      update();
    }else{
      favList.add(audioList.firstWhere((element) => element.audioId == musicId));
      SharedPreferences prefs =await SharedPreferences.getInstance();
      final String encodedData = MusicModel.encode([
        MusicModel(audioData:
        Audio('assets/Akon.mp3', metas: Metas(title: 'Akon',)),
            audioId: 0
        ),
        MusicModel(
          audioData:
          Audio('assets/bondok.mp3',
              metas: Metas(
                  title: 'Bondok',
                  image: MetasImage.network('https://raw.githubusercontent.com/florent37/Flutter-AssetsAudioPlayer/master/medias/notification_android.png')
              )),
          audioId: 1,

        ),
      ]);
      await prefs.setString(isFav, encodedData);
       // myList = favList.map((e) => e.audioData.metas.title.toString()).toList();
       // prefs.setStringList(isFav, myList);
       // print(favList.length);
       // print(myList);
      update();
    }
  }

  void getSongs()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
  final String? musicString =  prefs.getString(isFav);
  final List<MusicModel> musics = MusicModel.decode(musicString!);
     update();
  }

  bool isFavo(int Musicid){
   return favList.any((element) => element.audioId == Musicid);

  }

  void PickImage()async{
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    imagePicked = File(image!.path);
    saveImage(imagePicked!.path);
    update();
    await LoadedImage();
  }
  LoadedImage()async{
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    myImagePath =  saveImage.getString('imagepath');
    update();

  }
  void saveImage(path)async{
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    saveImage.setString('imagepath', path);
    update();

  }

}