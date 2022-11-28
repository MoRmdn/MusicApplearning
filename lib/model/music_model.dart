import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';

class MusicModel {
  Audio audioData;
  int audioId;

  MusicModel({
    required this.audioData,
    required this.audioId,
  });

  Map<String, dynamic> toJson() {
    return {
      'audioData': audioData,
      'audioId': audioData,
    };
  }

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
      audioData: json['audioData'],
      audioId: json['audioId'],
    );
  }

  static Map<String, dynamic> toMap(MusicModel music) => {
        'audioData': music.audioData,
        'audioId': music.audioId,
      };

  static String encode(List<MusicModel> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((music) => MusicModel.toMap(music))
            .toList(),
      );

  static List<MusicModel> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<MusicModel>((item) => MusicModel.fromJson(item))
          .toList();
}
