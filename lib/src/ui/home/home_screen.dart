import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pertama/src/bloc/anime/list_anime_bloc.dart';
import 'package:pertama/src/constant/colors.dart';
import 'package:pertama/src/constant/fonts.dart';
import 'package:pertama/src/model/anime/Anime.dart';
import 'package:pertama/src/ui/home/detail_anime.dart';
import 'package:pertama/src/widget/widget_card_loading.dart';


import '../appbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ListAnimeBloc _listAnimeBloc = ListAnimeBloc();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int page = 1;

  @override
  void initState() {
    _listAnimeBloc.add(ListAnimeEvent(1));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final double itemHeight = 330;
    final double itemWidth = 200;

    void nextPage(){
      int newPage = page+1;
      setState(() {
        page = newPage;
      });
      _listAnimeBloc.add(ListAnimeEvent(page));
    }
    void prevPage(){
      if(page>1){
        int newPage = page-1;
        print(newPage);
        setState(() {
          page = newPage;
        });
        _listAnimeBloc.add(ListAnimeEvent(page));
      }
    }
    return Scaffold(
      backgroundColor: Color(0xFF31336F),
      appBar: appBar(context),
      body: RefreshIndicator(
        key:  _refreshIndicatorKey,
        onRefresh: () {
          nextPage();
          _refreshIndicatorKey.currentState.deactivate();
         return Future.delayed(const Duration(seconds: 0));
        },
          child :BlocProvider<ListAnimeBloc>(
            create: (context) => _listAnimeBloc,
            child: BlocListener<ListAnimeBloc, ListAnimeState>(
              listener: (context, state) {
                if (state is Error) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                  ));
                }
              },
              child: BlocBuilder<ListAnimeBloc, ListAnimeState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return WidgetCardLoading();
                  } else if (state is Success) {
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
                                              Positioned(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      color: Colors.black
                                                  ),
                                                  padding: EdgeInsets.all(3),
                                                  child: Text(
                                                    row.totalEpisode,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11
                                                    ),
                                                  ),
                                                ),
                                                bottom: 5,
                                                left: 5,
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
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                InkWell(
                                  onTap: (){
                                    prevPage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: (page==1)?Colors.grey:Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Prev",
                                        style: TextStyle(
                                          fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                    nextPage();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        style: TextStyle(
                                            fontSize: 15
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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