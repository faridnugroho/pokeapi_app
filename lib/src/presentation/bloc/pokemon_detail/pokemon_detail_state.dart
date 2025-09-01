part of 'pokemon_detail_bloc.dart';

sealed class PokemonDetailState extends Equatable {
  const PokemonDetailState();

  @override
  List<Object?> get props => [];
}

final class PokemonDetailInitial extends PokemonDetailState {}

final class PokemonDetailLoading extends PokemonDetailState {}

final class PokemonDetailSuccess extends PokemonDetailState {
  final PokemonDetailModel pokemonDetail;
  const PokemonDetailSuccess(this.pokemonDetail);

  @override
  List<Object?> get props => [pokemonDetail];
}

final class PokemonDetailFailure extends PokemonDetailState {
  final String message;
  const PokemonDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
