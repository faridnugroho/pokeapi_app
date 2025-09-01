part of 'pokemon_detail_bloc.dart';

sealed class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemonDetail extends PokemonDetailEvent {
  final String name;

  const FetchPokemonDetail(this.name);

  @override
  List<Object?> get props => [name];
}
