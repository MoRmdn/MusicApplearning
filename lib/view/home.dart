import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/binding/music_binding.dart';
import 'package:musicapp/controller/controller.dart';
import 'package:musicapp/view/music_screen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  // final controller = Get.lazyPut(() => MusicController());
  MusicController controller = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            controller.LoadedImage();
            Get.to(
              MusicScreen(),
              binding: MusicBinding(),
            );
          },
          child: const Text('Music'),
        ),
      ),
    );
  }
}
