// To parse this JSON data, do
//
//     final animeDetail = animeDetailFromJson(jsonString);

import 'dart:convert';

AnimeDetail animeDetailFromJson(String str) => AnimeDetail.fromJson(json.decode(str));

String animeDetailToJson(AnimeDetail data) => json.encode(data.toJson());

class AnimeDetail {
  AnimeDetail({
    this.title,
    this.thumbnail,
    this.rating,
    this.totalEpisode,
    this.durasi,
    this.genre,
    this.sinopsis,
    this.episode,
  });

  String title;
  String thumbnail;
  String rating;
  String totalEpisode;
  String durasi;
  String genre;
  String sinopsis;
  List<Episode> episode;

  factory AnimeDetail.fromJson(Map<String, dynamic> json) => AnimeDetail(
    title: json["title"],
    thumbnail: json["thumbnail"],
    rating: json["rating"],
    totalEpisode: json["totalEpisode"],
    durasi: json["durasi"],
    genre: json["genre"],
    sinopsis: json["sinopsis"],
    episode: List<Episode>.from(json["episode"].map((x) => Episode.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "thumbnail": thumbnail,
    "rating": rating,
    "totalEpisode": totalEpisode,
    "durasi": durasi,
    "genre": genre,
    "sinopsis": sinopsis,
    "episode": List<dynamic>.from(episode.map((x) => x.toJson())),
  };
}

class Episode {
  Episode({
    this.title,
    this.url,
  });

  String title;
  String url;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
    title: json["title"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
  };
}
