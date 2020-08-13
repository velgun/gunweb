import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideo extends StatefulWidget {
  final String videoId;
  YoutubeVideo({Key key, this.videoId}) : super(key: key);

  @override
  _YoutubePlayerState createState() {
    return _YoutubePlayerState();
  }
}

class _YoutubePlayerState extends State<YoutubeVideo> {
  static YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  final GlobalKey playerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
  }

  static YoutubePlayer player;

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool showingDialog = false;

  @override
  Widget build(BuildContext context) {

    player = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
      bottomActions: [
        CurrentPosition(),
        ProgressBar(isExpanded: true),
        RemainingDuration(),
      ],
      onReady: () {
        _isPlayerReady = true;
      },
    );

    return player;


  }

}