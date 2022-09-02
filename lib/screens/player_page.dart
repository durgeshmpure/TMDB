import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class playerpage extends StatefulWidget {
  final String key1;
  const playerpage(this.key1);

  @override
  State<playerpage> createState() => _playerpageState();
}

class _playerpageState extends State<playerpage> {
  late YoutubePlayerController _controller;

  void runYoutubePlayer() {
    _controller = YoutubePlayerController(
        initialVideoId: widget.key1,
        flags: YoutubePlayerFlags(disableDragSeek: true,
            enableCaption: false, isLive: false, autoPlay: true));
  }

  @override
  void initState() {
    runYoutubePlayer();
    _controller.toggleFullScreenMode();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayerBuilder(
        builder: (context, player) => Scaffold(
          backgroundColor: Colors.black,body: Column(children: [
            player
          ],),
        ),
        player: YoutubePlayer(
          controller: _controller,
        ),
      ),
    );
  }
}
