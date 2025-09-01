import 'package:equatable/equatable.dart';
import 'package:pokeapi_app/src/domain/entities/pokemons_model.dart';

sealed class PokemonsState extends Equatable {
  const PokemonsState();

  @override
  List<Object?> get props => [];
}

final class PokemonInitial extends PokemonsState {}

final class PokemonLoading extends PokemonsState {}

final class PokemonSuccess extends PokemonsState {
  final List<Result> pokemons;
  const PokemonSuccess(this.pokemons);

  @override
  List<Object?> get props => [pokemons];
}

final class PokemonFailure extends PokemonsState {
  final String message;
  const PokemonFailure(this.message);

  @override
  List<Object?> get props => [message];
}
