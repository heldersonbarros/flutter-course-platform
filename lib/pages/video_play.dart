import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPage extends StatefulWidget {
  final video;
  const VideoPage({ Key? key, required this.video}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController ?_controller;
  Future<void> ?_initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video.video);
    _initializeVideoPlayerFuture = _controller!.initialize();
    _controller!.setLooping(true);
    _controller!.setVolume(1.0);
    _controller!.play();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done){
                return AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                );
              } else{
                return const Center(
                  child: CircularProgressIndicator());
              }
            },
            ),
            SizedBox(
              height: 20,
              child: VideoProgressIndicator(
                _controller!,  //video player controller
                allowScrubbing: true,
                colors: const VideoProgressColors( //video player progress bar
                    backgroundColor: Colors.grey,
                    playedColor: Colors.indigo,
                    bufferedColor: Colors.blueGrey,
                )
              ),
            ),
            ElevatedButton(onPressed: (){
              setState(() {
                if(_controller!.value.isPlaying){
                  _controller!.pause();
                } else{
                  _controller!.play();
                }
              });
            }, 
            child: Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow),
            style: ElevatedButton.styleFrom(
              primary: Colors.indigo
            ),
            )
        ],
      ),
    );
  }
}