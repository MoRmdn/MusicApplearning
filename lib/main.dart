import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicapp/controller/controller.dart';

import 'view/music_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MusicController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MusicScreen(),
    );
  }
}
