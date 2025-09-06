import 'dart:convert';

EvolutionChainModel evolutionChainModelFromJson(String str) => EvolutionChainModel.fromJson(json.decode(str));

String evolutionChainModelToJson(EvolutionChainModel data) => json.encode(data.toJson());

class EvolutionChainModel {
  final ChainLink? chain;

  EvolutionChainModel({this.chain});

  factory EvolutionChainModel.fromJson(Map<String, dynamic> json) =>
      EvolutionChainModel(chain: json["chain"] == null ? null : ChainLink.fromJson(json["chain"]));

  Map<String, dynamic> toJson() => {"chain": chain?.toJson()};
}

class ChainLink {
  final List<EvolutionDetail>? evolutionDetails;
  final List<ChainLink>? evolvesTo;
  final NamedResource? species;

  ChainLink({this.evolutionDetails, this.evolvesTo, this.species});

  factory ChainLink.fromJson(Map<String, dynamic> json) => ChainLink(
    evolutionDetails:
        json["evolution_details"] == null
            ? []
            : List<EvolutionDetail>.from(json["evolution_details"].map((x) => EvolutionDetail.fromJson(x))),
    evolvesTo:
        json["evolves_to"] == null ? [] : List<ChainLink>.from(json["evolves_to"].map((x) => ChainLink.fromJson(x))),
    species: json["species"] == null ? null : NamedResource.fromJson(json["species"]),
  );

  Map<String, dynamic> toJson() => {
    "evolution_details": evolutionDetails == null ? [] : List<dynamic>.from(evolutionDetails!.map((x) => x.toJson())),
    "evolves_to": evolvesTo == null ? [] : List<dynamic>.from(evolvesTo!.map((x) => x.toJson())),
    "species": species?.toJson(),
  };
}

class EvolutionDetail {
  final int? minLevel;
  final NamedResource? trigger;

  EvolutionDetail({this.minLevel, this.trigger});

  factory EvolutionDetail.fromJson(Map<String, dynamic> json) => EvolutionDetail(
    minLevel: json["min_level"],
    trigger: json["trigger"] == null ? null : NamedResource.fromJson(json["trigger"]),
  );

  Map<String, dynamic> toJson() => {"min_level": minLevel, "trigger": trigger?.toJson()};
}

class NamedResource {
  final String? name;
  final String? url;

  NamedResource({this.name, this.url});

  factory NamedResource.fromJson(Map<String, dynamic> json) => NamedResource(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}
