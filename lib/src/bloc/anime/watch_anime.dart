import 'package:bloc/bloc.dart';
import 'package:pertama/src/api/api_provider.dart';
import 'package:pertama/src/constant/string.dart';
import 'package:pertama/src/model/anime/WatchAnime.dart';

abstract class WatchAnimeState {}

class Initial extends WatchAnimeState {}

class LoadingWatchAnime extends WatchAnimeState {}

class ErrorWatchAnime extends WatchAnimeState {
  final String error;
  ErrorWatchAnime(this.error);
}
class Exception extends WatchAnimeState {
  final String error;
  Exception(this.error);
}
class SuccessWatchAnime extends WatchAnimeState {
  final WatchAnime animeWatch;
  SuccessWatchAnime(this.animeWatch);
}

class WatchAnimeEvent extends WatchAnimeState {
  final String name;
  WatchAnimeEvent(this.name);
}

class WatchAnimeBloc extends Bloc<WatchAnimeEvent, WatchAnimeState> {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  WatchAnimeState get initialState => Initial();

  @override
  Stream<WatchAnimeState> mapEventToState(WatchAnimeEvent event) async* {
    print("call request");
    yield LoadingWatchAnime();
    final request =  await _apiProvider.getAnimeByName(event.name);
    Map<String, dynamic> response = request;
    int apiStatus = response[StringUtils.ApiStatus];
    String apiMessage = response[StringUtils.ApiMessage];
    WatchAnime anime = new WatchAnime();
    try{
      dynamic data = response['data'];
      anime = WatchAnime.fromJson(data);
    }catch(e){
      print("error");
      print(e.toString());
      yield ErrorWatchAnime(e.toString());
      return;
    }
    if (apiStatus == 0) {
      yield ErrorWatchAnime(apiMessage);
      return;
    }
    yield SuccessWatchAnime(anime);
  }

}