import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicapp/constants/app_strings.dart';
import 'package:musicapp/model/music_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late List<String> myFavList;
  late SharedPreferences prefs;
  List<MusicModel> audioList = [
    MusicModel(
        audioData: Audio('assets/Akon.mp3',
            metas: Metas(
              title: 'Akon',
            )),
        audioId: 0),
    MusicModel(
      audioData: Audio('assets/bondok.mp3',
          metas: Metas(
              title: 'Bondok',
              image: const MetasImage.network(
                  'https://raw.githubusercontent.com/florent37/Flutter-AssetsAudioPlayer/master/medias/notification_android.png'))),
      audioId: 1,
    ),
  ];
  List<String> myList = [];

  List<MusicModel> favList = [];
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    myFavList = prefs.getStringList(AppStrings.favMusicIds) ?? [];
    setupPlayList();
    LoadedImage();
    getSongs();
    getFav();
  }

  void getFav() {
    for (var id in myFavList) {
      int musicId = int.parse(id);
      var music = audioList.firstWhere((element) => element.audioId == musicId);
      favList.add(music);
    }
  }

  bool isFavourites = false;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  File? image;
  ImagePicker imagePicker = ImagePicker();
  var isSearch = false.obs;
  String isFav = 'isFav';
  String? token;
  late bool liked = false;

  Widget searchField() {
    return TextFormField(
      onChanged: (value) {
        searchEngine(value);
        update();
      },
      decoration: const InputDecoration(
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
  void searchEngine(String searchItem) {
    //searchItems = audioList.values;
    searchItems.value = audioList
        .where((element) => element.audioData.metas.title!
            .toLowerCase()
            .contains(searchItem.toLowerCase()))
        .toList();
    // searchItems = audioList.where((element) => element.audioData.metas.title!.toLowerCase().startsWith(searchItem.toLowerCase())).toList();
    update();
  }

  late AnimationController animationController;
  void setupPlayList() async {
    await audioPlayer.open(
      Playlist(audios: audioList.map((e) => e.audioData).toList()),
      showNotification: true,
      autoStart: false,
      loopMode: LoopMode.playlist,
    );
  }

  void manageFavourites(int musicId) async {
    var existingIndex =
        favList.indexWhere((element) => element.audioId == musicId);
    if (existingIndex >= 0) {
      favList.removeAt(existingIndex);
      myFavList.removeAt(existingIndex);
      prefs.setStringList(AppStrings.favMusicIds, myFavList);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // myList = favList.map((e) => e.audioData.metas.title.toString()).toList();
      // prefs.setStringList(isFav, myList);
      // prefs.setInt(isFav, musicId);

      update();
    } else {
      final music =
          audioList.firstWhere((element) => element.audioId == musicId);
      favList.add(music);
      myFavList.add(musicId.toString());
      //* write in cache
      prefs.setStringList(AppStrings.favMusicIds, myFavList);
      // _favMusicBox.put(musicId, music);

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final String encodedData = MusicModel.encode([
      //   MusicModel(
      //       audioData: Audio('assets/Akon.mp3',
      //           metas: Metas(
      //             title: 'Akon',
      //           )),
      //       audioId: 0),
      //   MusicModel(
      //     audioData: Audio('assets/bondok.mp3',
      //         metas: Metas(
      //             title: 'Bondok',
      //             image: const MetasImage.network(
      //                 'https://raw.githubusercontent.com/florent37/Flutter-AssetsAudioPlayer/master/medias/notification_android.png'))),
      //     audioId: 1,
      //   ),
      // ]);
      // await prefs.setString(isFav, encodedData);
      // myList = favList.map((e) => e.audioData.metas.title.toString()).toList();
      // prefs.setStringList(isFav, myList);
      // print(favList.length);
      // print(myList);
      update();
    }
  }

  void getSongs() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String? musicString = prefs.getString(isFav);
    // final List<MusicModel> musics = MusicModel.decode(musicString!);
    update();
  }

  bool isFavo(int Musicid) {
    return favList.any((element) => element.audioId == Musicid);
  }

  void PickImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    imagePicked = File(image!.path);
    saveImage(imagePicked!.path);
    update();
    await LoadedImage();
  }

  LoadedImage() async {
    //? don't repeat yourSelf
    // SharedPreferences saveImage = await SharedPreferences.getInstance();
    myImagePath = prefs.getString('imagepath');
    update();
  }

  void saveImage(path) async {
    //? don't repeat yourSelf
    // SharedPreferences saveImage = await SharedPreferences.getInstance();
    prefs.setString('imagepath', path);
    update();
  }
}
