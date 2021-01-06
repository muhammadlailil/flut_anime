import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pertama/src/bloc/anime/list_anime_bloc.dart';
import 'package:pertama/src/bloc/anime/search_anime_bloc.dart';
import 'package:pertama/src/constant/colors.dart';
import 'package:pertama/src/constant/fonts.dart';
import 'package:pertama/src/model/anime/Anime.dart';
import 'package:pertama/src/ui/home/detail_anime.dart';
import 'package:pertama/src/widget/widget_card_loading.dart';


import '../appbar.dart';

class SearchScreen extends StatefulWidget {
  final String search;
  SearchScreen({Key key, @required this.search}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ListSearchAnimeBloc _listAnimeBloc = ListSearchAnimeBloc();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _listAnimeBloc.add(ListSearchAnimeEvent(widget.search));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final double itemHeight = 330;
    final double itemWidth = 200;

    return Scaffold(
      backgroundColor: Color(0xFF31336F),
      appBar: appBar(context),
      body: RefreshIndicator(
        key:  _refreshIndicatorKey,
        onRefresh: () {
          _listAnimeBloc.add(ListSearchAnimeEvent(widget.search));
          _refreshIndicatorKey.currentState.deactivate();
         return Future.delayed(const Duration(seconds: 0));
        },
          child :BlocProvider<ListSearchAnimeBloc>(
            create: (context) => _listAnimeBloc,
            child: BlocListener<ListSearchAnimeBloc, ListSearchAnimeState>(
              listener: (context, state) {
                if (state is ErrorSearch) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                  ));
                }
              },
              child: BlocBuilder<ListSearchAnimeBloc, ListSearchAnimeState>(
                builder: (context, state) {
                  if (state is LoadingSearch) {
                    return WidgetCardLoading();
                  } else if (state is SuccessSearch) {
                    List<Anime> anime = state.anime;
                    return Container(
                      margin: EdgeInsets.all(13),
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: GridView.count(
                              childAspectRatio: (itemWidth / itemHeight),
                              crossAxisCount: 3,
                              children: List.generate(anime.length, (index) {
                                Anime row = anime[index];
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(3, 3, 3, 0),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(7),
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => DetailAnime(animeName: row.url,)),
                                      );
                                    },
                                    child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          height: 180,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(7),
                                              image: DecorationImage(
                                                  image: NetworkImage(row.thumbnail),
                                                  fit: BoxFit.cover
                                              )
                                          ),
                                          child: Stack(
                                            alignment: AlignmentDirectional.bottomCenter,
                                            overflow: Overflow.visible,
                                            children: <Widget>[
                                              Positioned(
                                                child:  Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.orange
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: Text(
                                                    row.rating,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11
                                                    ),
                                                  ),
                                                ),
                                                right: 5,
                                                bottom: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Text(
                                          row.title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontFamily: CustomFonts.bold
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
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