import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:ui' as ui;
class ApiConnection{

  String link = "https://fxnode.ru/api/tilemap/";

  Future<ui.Image> get_map (String endpoint) async{
    final response = await Dio().get(
        "$link/$endpoint"
    );
    final data = response.data as Map<dynamic,dynamic>;
    String b64 = data["data"];
    Uint8List byteImage = const Base64Decoder().convert(b64);
    ui.Codec codec = await ui.instantiateImageCodec(byteImage);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    return frameInfo.image;
  }

  Future<List> get_another_data() async{
    final response = await Dio().get(
        "$link/raster"
    );
    return response.data;

  }
}