/*
The MIT License (MIT)

Copyright (c) 2019 Sarbagya Dhaubanjar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playing_youtube/main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Youtube再生アプリ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(color: Colors.red),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      home: MyHomePage(title: 'Youtube再生アプリ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  //再生や停止等のコントロールを行うクラスのインスタンス化
  YoutubePlayerController _controller = YoutubePlayerController();

  //入力されたYouTube動画のURLやIDをいじるためのクラスのインスタンス化
  var _idController = TextEditingController();

  //再生されるID
  String _videoId = "";

  bool _muted = true;
  double _volume = 100;


  // このアプリが非アクティブになっている間は、動画再生を停止する
  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        )
      ),
    )
  }
}