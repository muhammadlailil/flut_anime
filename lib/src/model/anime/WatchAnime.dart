// To parse this JSON data, do
//
//     final watchAnime = watchAnimeFromJson(jsonString);

import 'dart:convert';

WatchAnime watchAnimeFromJson(String str) => WatchAnime.fromJson(json.decode(str));

String watchAnimeToJson(WatchAnime data) => json.encode(data.toJson());

class WatchAnime {
  WatchAnime({
    this.title,
    this.url,
    this.prevUrl,
    this.nextUrl,
  });

  String title;
  String url;
  String prevUrl;
  dynamic nextUrl;

  factory WatchAnime.fromJson(Map<String, dynamic> json) => WatchAnime(
    title: json["title"],
    url: json["url"],
    prevUrl: json["prevUrl"],
    nextUrl: json["nextUrl"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "url": url,
    "prevUrl": prevUrl,
    "nextUrl": nextUrl,
  };
}
