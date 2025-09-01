part of 'pokemon_species_bloc.dart';

sealed class PokemonSpeciesState extends Equatable {
  const PokemonSpeciesState();

  @override
  List<Object?> get props => [];
}

final class PokemonSpeciesInitial extends PokemonSpeciesState {}

final class PokemonSpeciesLoading extends PokemonSpeciesState {}

final class PokemonSpeciesSuccess extends PokemonSpeciesState {
  final PokemonSpeciesModel pokemonSpecies;
  const PokemonSpeciesSuccess(this.pokemonSpecies);

  @override
  List<Object?> get props => [pokemonSpecies];
}

final class PokemonSpeciesFailure extends PokemonSpeciesState {
  final String message;
  const PokemonSpeciesFailure(this.message);

  @override
  List<Object?> get props => [message];
}
