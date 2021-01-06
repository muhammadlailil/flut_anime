import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pertama/src/bloc/anime/detail_anime.dart';
import 'package:pertama/src/bloc/anime/list_anime_bloc.dart';
import 'package:pertama/src/constant/fonts.dart';
import 'package:pertama/src/model/anime/AnimeDetail.dart';
import 'package:pertama/src/ui/appbar.dart';
import 'package:pertama/src/ui/home/watch_anime.dart';
import 'package:pertama/src/widget/widget_card_loading.dart';

class DetailAnime extends StatefulWidget {
  final String animeName;
  DetailAnime({Key key, @required this.animeName}) : super(key: key);
  @override
  _DetailAnimeState createState() => _DetailAnimeState();
}

class _DetailAnimeState extends State<DetailAnime> {
  final DetailAnimeBloc _detailAnimeBloc = DetailAnimeBloc();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _detailAnimeBloc.add(DetailAnimeEvent(widget.animeName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF31336F),
      appBar: appBar(context),
      body: RefreshIndicator(
        key:  _refreshIndicatorKey,
        onRefresh: () {
          _detailAnimeBloc.add(DetailAnimeEvent(widget.animeName));
          _refreshIndicatorKey.currentState.deactivate();
          return Future.delayed(const Duration(seconds: 0));
        },
        child :BlocProvider<DetailAnimeBloc>(
          create: (context) => _detailAnimeBloc,
          child: BlocListener<DetailAnimeBloc, DetailAnimeState>(
            listener: (context, state) {
              if (state is ErrorDetailAnime) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                ));
              }
            },
            child: BlocBuilder<DetailAnimeBloc, DetailAnimeState>(
              builder: (context, state) {
                if (state is LoadingDetailAnime) {
                  return WidgetCardLoading();
                } else if (state is SuccessDetailAnime) {
                  AnimeDetail anime = state.animeDetail;
                  return Padding(
                    padding: EdgeInsets.all(13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 140,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(anime.thumbnail),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    anime.title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: CustomFonts.bold
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Rating : ${anime.rating}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: CustomFonts.regular,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Total Episode : ${anime.totalEpisode}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: CustomFonts.regular,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Durasi : ${anime.durasi}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: CustomFonts.regular,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "Genre :",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: CustomFonts.regular,
                                        fontSize: 14
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Text(
                                    "${anime.genre}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: CustomFonts.regular,
                                        fontSize: 14
                                    ),
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10,),
//                        Text(
//                          "Sinopsis :",
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontFamily: CustomFonts.regular,
//                              fontSize: 14
//                          ),
//                        ),
//                        SizedBox(height: 10,),
//                        Text(
//                          "${anime.sinopsis}",
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontFamily: CustomFonts.regular,
//                              fontSize: 14
//                          ),
//                        ),
                        Expanded(
//                          height: MediaQuery.of(context).size.height/1.45,
                          child: ListView.builder(
                            itemBuilder: (ctx,index){
                              Episode ep = anime.episode[index];
                              return Padding(
                                padding: EdgeInsets.only(top: 5,bottom: 5),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => WatchAnime(animeName: ep.url,episode: anime.episode,thumbnail: anime.thumbnail,)),
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
                            itemCount: anime.episode.length,
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
