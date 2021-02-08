import 'package:PublicHealth/main.dart';
import 'package:flutter/material.dart';
import '../ph_theme.dart';
import 'package:PublicHealth/src/ph/models/materials.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoLessionView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final Materials videoData;

  const VideoLessionView(
      {Key key, this.animationController, this.animation, this.videoData})
      : super(key: key);

  @override
  _VideoLessionViewState createState() => _VideoLessionViewState();
}

class _VideoLessionViewState extends State<VideoLessionView> {
  // ChewieController _chewieController;
  YoutubePlayerController _controller;
  // VideoPlayerController _controller;
  Materials videoDta;
  String errorMessage;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoData.link),
      flags: YoutubePlayerFlags(
          enableCaption: false, autoPlay: false, isLive: false),
    );
    // _chewieController = ChewieController(
    //   videoPlayerController: _controller,
    //   aspectRatio: 16 / 9,
    //   autoInitialize: true,
    //   looping: true,
    //   errorBuilder: (context, errorMessage) {
    //     return Center(
    //       child: Icon(Icons.error),
    //     );
    //   },
    // );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [PHTheme.nearlyDarkBlue, HexColor("#6F56E8")],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: PHTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Latest New Video',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: PHTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: PHTheme.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.videoData.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: PHTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            color: PHTheme.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: PHTheme.white,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                _controller.metadata.duration.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: PHTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: PHTheme.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: PHTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          PHTheme.nearlyBlack.withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: InkWell(
                                  child: Icon(
                                    Icons.arrow_right,
                                    color: HexColor("#6F56E8"),
                                    size: 44,
                                  ),     
                                  onTap: () {
                                    //Dialog Start here
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)), //this right here
                                            child: Container(
                                              height: 250,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: YoutubePlayerBuilder(
                                                  player: YoutubePlayer(
                                                    controller: _controller,
                                                  ),
                                                  builder: (context, player) {
                                                    return Text("Nice player");
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                    //Dialog Ends here
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
