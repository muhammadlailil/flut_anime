import 'package:bloc/bloc.dart';
import 'package:pertama/src/api/api_provider.dart';
import 'package:pertama/src/constant/string.dart';
import 'package:pertama/src/model/anime/Anime.dart';

abstract class ListSearchAnimeState {}

class Initial extends ListSearchAnimeState {}

class LoadingSearch extends ListSearchAnimeState {}

class ErrorSearch extends ListSearchAnimeState {
  final String error;
  ErrorSearch(this.error);
}
class Exception extends ListSearchAnimeState {
  final String error;
  Exception(this.error);
}
class SuccessSearch extends ListSearchAnimeState {
  final List<Anime> anime;
  SuccessSearch(this.anime);
}

class ListSearchAnimeEvent  extends ListSearchAnimeState{
  final String search;
  ListSearchAnimeEvent(this.search);
}

class ListSearchAnimeBloc extends Bloc<ListSearchAnimeEvent, ListSearchAnimeState> {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  ListSearchAnimeState get initialState => Initial();

  @override
  Stream<ListSearchAnimeState> mapEventToState(ListSearchAnimeEvent event) async* {
    print("call request");
    yield LoadingSearch();
    final request =  await _apiProvider.getSearchAnime(event.search);
    Map<String, dynamic> response = request;
    int apiStatus = response[StringUtils.ApiStatus];
    String apiMessage = response[StringUtils.ApiMessage];
    List<Anime> anime = [];
    try{
      List<dynamic> data = response['data'];
      data.forEach((row) {
        Anime item = Anime.fromJson(row);
        anime.add(item);
      });
    }catch(e){
      print("error");
      print(e.toString());
      yield ErrorSearch(e.toString());
      return;
    }
    if (apiStatus == 0) {
      yield ErrorSearch(apiMessage);
      return;
    }
    yield SuccessSearch(anime);
  }

}