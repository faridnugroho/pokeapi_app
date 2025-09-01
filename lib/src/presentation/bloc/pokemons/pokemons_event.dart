import 'package:equatable/equatable.dart';

sealed class PokemonsEvent extends Equatable {
  const PokemonsEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemons extends PokemonsEvent {}
