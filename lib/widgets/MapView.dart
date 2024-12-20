import 'package:flutter/material.dart';
import 'Tile.dart';


class MapView extends CustomPainter{
  Tile tile;
  List<int> levels;
  List<int> x_tiles = [];
  List<int> y_tiles = [];
  double x0 = 0;
  double y0 = 0;
  double x1 = 0;
  double y1 = 0;


  MapView({
    required this.levels,
    required this.x_tiles,
    required this.y_tiles,
    required this.tile,
    required this.x0,
    required this.y0,
    required this.x1,
    required this.y1
  });

  Paint p = Paint();
  int curent_level = 0;

  @override
  void paint(Canvas canvas, Size size) {
    int w = x_tiles[curent_level];
    int h = y_tiles[curent_level];
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        try {
          canvas.drawRect(Rect.fromLTRB(x0, y0, x1, y1), p);
        }
        catch (Ex) {
          debugPrint(Ex.toString());
        }
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}