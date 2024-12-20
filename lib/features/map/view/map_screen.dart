import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mobilelab_map/widgets/ApiConnection.dart';
import 'package:mobilelab_map/widgets/MapView.dart';
import 'package:mobilelab_map/widgets/Tile.dart';


class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Tile> tiles = [];
  List<int> levels = [16,8,4,2,1];
  List<int> x_tiles = [54,108,216,432,864];
  List<int> y_tiles = [27,54,108,216,432];
  Tile? t;
  double main_x0 = 0;
  double main_y0 = 0;
  double main_x1 = 0;
  double main_y1 = 0;
  @override
  void initState() {
    _get_data();
    main();
    super.initState();
  }

  void _get_data() async{
    final List<int> levels_async = [];
    final List<int> x_tiles_async = [];
    final List<int> y_tiles_async = [];
    List data = await ApiConnection().get_another_data();
    for(int i=0; i < data.length;i++){
      levels_async.add(data[i]["level"]);
      x_tiles_async.add(data[i]["xtiles"]);
      y_tiles_async.add(data[i]["ytiles"]);
    }
    setState(() {
      levels = levels_async;
      x_tiles = x_tiles_async;
      y_tiles = y_tiles_async;
    });

  }
  void main() {
    Future<ui.Image> _get_img(int x, int y, int scale) async {
      ui.Image _image = await ApiConnection().get_map("raster/$scale/$x-$y");
      return _image;
    }

    Future<Tile> get_tile(int x, int y, int scale) async {
      for (int i = 0; i < tiles.length; i++) {
        Tile tile = tiles[i];
        if (tile.x == x && tile.y == y && tile.scale == y) {
          return tile;
        }
      }
      ui.Image img = await _get_img(x, y, scale);
      Tile t = Tile(scale: scale, x: x, y: y, img: img);
      return t;
    }


    double last_x = 0.0;
    double last_y = 0.0;
    int curent_level = 0;
    int tile_width = 100;
    int tile_height = 100;
    double offset_x = 0.0;
    double offset_y = 0.0;
    Paint p = Paint();
    double width = 0;
    double height = 0;

    bool rect_intersects(double ax0, double ay0, double ax1, double ay1,
        double bx0, double by0, double bx1, double by1) {
      if (ax1 < bx0) return false;
      if (ax0 > bx1) return false;
      if (ay1 < by0) return false;
      if (ay0 > bx1) return false;
      return true;
    }



    if (levels.isNotEmpty) {

      width = 686;
      height = 554;

      double screen_x0 = 0;
      double screen_y0 = 0;
      double screen_x1 = 686 - 1;
      double screen_y1 = 554 - 1;

      int w = x_tiles[curent_level];
      int h = y_tiles[curent_level];

      for (int y = 0; y < h; y++) {
        for (int x = 0; x < w; x++) {
          double x0 = x * tile_width + offset_x;
          double y0 = y * tile_height + offset_y;
          double x1 = x0 + tile_width;
          double y1 = y0 + tile_height;

          if (rect_intersects(
              screen_x0,
              screen_y0,
              screen_x1,
              screen_y1,
              x0,
              y0,
              x1,
              y1)) {
            continue;
          }

          get_tile(x, y, levels[curent_level]).then((onValue) {
            setState(() {
              t = onValue;
              main_x0 = x0;
              main_y0 = y0;
              main_x1 = x1;
              main_y1 = y1;
            });
          });
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Карта"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: Container(
                decoration:BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(0,0.0,0,0.0),
                  child: LayoutBuilder(builder: (_,constraints)=>Container(
                    width: 686,
                    height: 554,
                    color: Colors.greenAccent,
                    child: (t == null)
                    ? const Center(child:CircularProgressIndicator())
                    :CustomPaint(painter: MapView(
                      levels: levels,
                      x_tiles: x_tiles,
                      y_tiles: y_tiles,
                      tile: t as Tile,
                      x0: main_x0,
                      y0: main_y0,
                      x1:main_x1,
                      y1: main_y1
                    )),
                  )
                  ),
                  ),

                ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    onPressed: (){},
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey),
                      foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Icon(Icons.zoom_out)

                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10.0,0,10.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: (){},
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey),
                        foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                      ),
                      child: const Icon(Icons.zoom_in)),
                ),
              )
            ],
          )
        ],
      )
    );
  }
}