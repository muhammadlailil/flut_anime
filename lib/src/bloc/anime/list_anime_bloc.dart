import 'package:bloc/bloc.dart';
import 'package:pertama/src/api/api_provider.dart';
import 'package:pertama/src/constant/string.dart';
import 'package:pertama/src/model/anime/Anime.dart';

abstract class ListAnimeState {}

class Initial extends ListAnimeState {}

class Loading extends ListAnimeState {}

class Error extends ListAnimeState {
  final String error;
  Error(this.error);
}
class Exception extends ListAnimeState {
  final String error;
  Exception(this.error);
}
class Success extends ListAnimeState {
  final List<Anime> anime;
  Success(this.anime);
}

class ListAnimeEvent  extends ListAnimeState{
  final int page;
  ListAnimeEvent(this.page);
}

class ListAnimeBloc extends Bloc<ListAnimeEvent, ListAnimeState> {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  ListAnimeState get initialState => Initial();

  @override
  Stream<ListAnimeState> mapEventToState(ListAnimeEvent event) async* {
    print("call request");
    yield Loading();
    final request =  await _apiProvider.getAllAnime(event.page);
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
      yield Error(e.toString());
      return;
    }
    if (apiStatus == 0) {
      yield Error(apiMessage);
      return;
    }
    yield Success(anime);
  }

}