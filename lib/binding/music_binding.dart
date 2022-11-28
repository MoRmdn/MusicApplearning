import 'package:get/get.dart';
import 'package:musicapp/controller/controller.dart';

class MusicBinding extends Bindings{
  @override
  void dependencies() {
   Get.put(MusicController());
  }

}