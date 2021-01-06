import 'package:bloc/bloc.dart';
import 'package:pertama/src/api/api_provider.dart';
import 'package:pertama/src/constant/string.dart';
import 'package:pertama/src/model/anime/AnimeDetail.dart';

abstract class DetailAnimeState {}

class Initial extends DetailAnimeState {}

class LoadingDetailAnime extends DetailAnimeState {}

class ErrorDetailAnime extends DetailAnimeState {
  final String error;
  ErrorDetailAnime(this.error);
}
class Exception extends DetailAnimeState {
  final String error;
  Exception(this.error);
}
class SuccessDetailAnime extends DetailAnimeState {
  final AnimeDetail animeDetail;
  SuccessDetailAnime(this.animeDetail);
}

class DetailAnimeEvent extends DetailAnimeState {
  final String name;
  DetailAnimeEvent(this.name);
}

class DetailAnimeBloc extends Bloc<DetailAnimeEvent, DetailAnimeState> {
  final ApiProvider _apiProvider = ApiProvider();

  @override
  DetailAnimeState get initialState => Initial();

  @override
  Stream<DetailAnimeState> mapEventToState(DetailAnimeEvent event) async* {
    print("call request");
    yield LoadingDetailAnime();
    final request =  await _apiProvider.getAnimeByName(event.name);
    Map<String, dynamic> response = request;
    int apiStatus = response[StringUtils.ApiStatus];
    String apiMessage = response[StringUtils.ApiMessage];
    AnimeDetail anime = new AnimeDetail();
    try{
      dynamic data = response['data'];
      anime = AnimeDetail.fromJson(data);
    }catch(e){
      print("error");
      print(e.toString());
      yield ErrorDetailAnime(e.toString());
      return;
    }
    if (apiStatus == 0) {
      yield ErrorDetailAnime(apiMessage);
      return;
    }
    yield SuccessDetailAnime(anime);
  }

}