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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main(){
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white,
  ));
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
        appBarTheme: AppBarTheme(color: Colors.green),
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
  String _videoId = "zhCtzmDWsN0";

  bool _muted = false;
  double _volume = 100;


  // アプリが非アクティブになっている間は、動画再生を停止する
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
            style: TextStyle(color: Colors.white)
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            YoutubePlayer(
              context: context,
              videoId: _videoId,
              flags: YoutubePlayerFlags(
                mute: false,
                autoPlay: true,
                forceHideAnnotation: true,
                showVideoProgressIndicator: true,
                disableDragSeek: false,
                loop: false,
              ),
              progressIndicatorColor: Colors.black,
              topActions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: (){
                    _controller.exitFullScreen();
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: (){},
                ),
              ],
              onPlayerInitialized: (controller){
                _controller = controller;
                _controller.addListener(listener);
              }, // onPlayerInitialized
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _idController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "YoutubeのリンクかURLを入力してください",
                      hintStyle: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //Wedgetにタッチインタフェースを使う時に使う
                  InkWell(
                    //タップしたら処理
                    onTap: (){
                      setState(() {
                        if(!(_idController.text == "")){
                          _videoId = _idController.text;
                          try{
                            //URLの場合は、対応するIDに変換する
                            if(_videoId.contains("http")){
                              _videoId = YoutubePlayer.convertUrlToId(_videoId);
                            }
                          }catch(e){

                          }
                        }else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("読み込みエラー"),
                                content: Text("何も入力されていません"),
                              );
                            },
                          );
                        }
                      });
                    }, //onTap
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      color: Colors.green,
                      child: Text(
                        "検索",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.play_arrow
                              : Icons.pause,
                        ),
                        onPressed: () {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons.volume_up),
                        onPressed: () {
                          _muted ? _controller.unMute() : _controller.mute();
                          setState(() {
                            _muted = !_muted;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.fullscreen),
                        onPressed: () => _controller.enterFullScreen(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "音量",
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Expanded(
                        child: Slider(
                          inactiveColor: Colors.transparent,
                          value: _volume,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          label: '${(_volume).round()}',
                          onChanged: (value) {
                            setState(() {
                              _volume = value;
                            });
                            _controller.setVolume(_volume.round());
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  } // <Widget>[]

  void listener(){
    if(_controller.value.playerState == PlayerState.ended){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("再生終了"),
            content: Text("次もよろしくね！"),
          );
        },
      );
    }
  }
}
