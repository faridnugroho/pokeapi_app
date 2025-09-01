part of 'pokemon_species_bloc.dart';

sealed class PokemonSpeciesEvent extends Equatable {
  const PokemonSpeciesEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemonSpecies extends PokemonSpeciesEvent {
  final String name;

  const FetchPokemonSpecies(this.name);

  @override
  List<Object?> get props => [name];
}
