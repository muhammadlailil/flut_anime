// To parse this JSON data, do
//
//     final anime = animeFromJson(jsonString);

import 'dart:convert';

List<Anime> animeFromJson(String str) => List<Anime>.from(json.decode(str).map((x) => Anime.fromJson(x)));

String animeToJson(List<Anime> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Anime {
  Anime({
    this.title,
    this.thumbnail,
    this.url,
    this.totalEpisode,
    this.rating,
  });

  String title;
  String thumbnail;
  String url;
  String totalEpisode;
  String rating;

  factory Anime.fromJson(Map<String, dynamic> json) => Anime(
    title: json["title"],
    thumbnail: json["thumbnail"],
    url: json["url"],
    totalEpisode: (json["totalEpisode"]!=null)?json["totalEpisode"]:'',
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "thumbnail": thumbnail,
    "url": url,
    "totalEpisode": totalEpisode,
    "rating": rating,
  };
}
