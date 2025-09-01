import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapi_app/src/domain/usecases/pokemons_usecase.dart';
import 'pokemons_event.dart';
import 'pokemons_state.dart';

class PokemonsBloc extends Bloc<PokemonsEvent, PokemonsState> {
  final PokemonsUseCase pokemonUseCase;

  PokemonsBloc(this.pokemonUseCase) : super(PokemonInitial()) {
    on<FetchPokemons>((event, emit) async {
      emit(PokemonLoading());
      try {
        final response = await pokemonUseCase();
        final results = response.results ?? [];

        emit(PokemonSuccess(results));
      } catch (e) {
        emit(PokemonFailure(e.toString()));
      }
    });
  }
}
