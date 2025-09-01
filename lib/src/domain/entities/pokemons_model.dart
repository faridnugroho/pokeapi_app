import 'dart:convert';

PokemonsModel pokemonsModelFromJson(String str) => PokemonsModel.fromJson(json.decode(str));

String pokemonsModelToJson(PokemonsModel data) => json.encode(data.toJson());

class PokemonsModel {
  final int? count;
  final String? next;
  final dynamic previous;
  final List<Result>? results;

  PokemonsModel({this.count, this.next, this.previous, this.results});

  factory PokemonsModel.fromJson(Map<String, dynamic> json) => PokemonsModel(
    count: json["count"],
    next: json["next"],
    previous: json["previous"],
    results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next": next,
    "previous": previous,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  final String? name;
  final String? url;

  Result({this.name, this.url});

  factory Result.fromJson(Map<String, dynamic> json) => Result(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
