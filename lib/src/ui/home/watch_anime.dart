import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pertama/src/bloc/anime/detail_anime.dart';
import 'package:pertama/src/bloc/anime/watch_anime.dart';
import 'package:pertama/src/model/anime/AnimeDetail.dart';
import 'package:pertama/src/ui/appbar.dart';
import 'package:pertama/src/widget/widget_card_loading.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';



class WatchAnime extends StatefulWidget {
  final String animeName;
  final List<Episode> episode;
  final String thumbnail;
  WatchAnime({Key key, @required this.animeName,@required this.episode,@required this.thumbnail}) : super(key: key);
  @override
  _WatchAnimeState createState() => _WatchAnimeState();
}

class _WatchAnimeState extends State<WatchAnime> {
  final WatchAnimeBloc _watchAnimeBloc = WatchAnimeBloc();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  Completer<WebViewController> _controller;

  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  @override
  void initState() {
    _controller = Completer<WebViewController>();
    _watchAnimeBloc.add(WatchAnimeEvent(widget.animeName));
    super.initState();
  }
  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
  void _dispose(){
    _videoPlayerController1.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31336F),
      appBar: appBar(context),
      body: RefreshIndicator(
        key:  _refreshIndicatorKey,
        onRefresh: () {
          _watchAnimeBloc.add(WatchAnimeEvent(widget.animeName));
          _refreshIndicatorKey.currentState.deactivate();
          return Future.delayed(const Duration(seconds: 0));
        },
        child :BlocProvider<WatchAnimeBloc>(
          create: (context) => _watchAnimeBloc,
          child: BlocListener<WatchAnimeBloc, WatchAnimeState>(
            listener: (context, state) {
              if (state is ErrorWatchAnime) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                ));
              }
            },
            child: BlocBuilder<WatchAnimeBloc, WatchAnimeState>(
              builder: (context, state) {
                if (state is LoadingWatchAnime) {
                  return WidgetCardLoading();
                } else if (state is SuccessWatchAnime) {
                  return Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: Center(
                            child: Chewie(
                              controller: _chewieController = ChewieController(
                                videoPlayerController: _videoPlayerController1 = VideoPlayerController.network(
                                    state.animeWatch.url
                                ),
                                aspectRatio: 3.5 / 2,
                                autoPlay: false,
                                looping: false,
                                autoInitialize: true,
                                placeholder: Container(
                                  color: Colors.black,
                                  child: Center(
                                    child: Image(
                                      image: NetworkImage(widget.thumbnail),
                                    ),
                                  ),
                                ),
                                // autoInitialize: true,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(13),
                          child: Text(
                            state.animeWatch.title,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            ),
                          ),
                        ),
                        Expanded(
//                          height: MediaQuery.of(context).size.height/1.45,
                          child: ListView.builder(
                            itemBuilder: (ctx,index){
                              Episode ep = widget.episode[index];
                              return Padding(
                                padding: EdgeInsets.only(top: 5,bottom: 5,left: 13,right: 13),
                                child: InkWell(
                                  onTap: (){
                                    _dispose();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => WatchAnime(animeName: ep.url,episode: widget.episode,thumbnail: widget.thumbnail,)),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),bottomLeft: Radius.circular(5)),
                                            color: Colors.orange,
                                          ),
                                          width: 30,
                                          height: 30,
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ep.title,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: widget.episode.length,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
