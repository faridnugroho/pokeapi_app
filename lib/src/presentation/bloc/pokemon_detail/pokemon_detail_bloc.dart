import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_detail_model.dart';
import 'package:pokeapi_app/src/domain/usecases/pokemon_detail_usecase.dart';

part 'pokemon_detail_event.dart';
part 'pokemon_detail_state.dart';

class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonDetailUseCase pokemonDetailUseCase;

  PokemonDetailBloc(this.pokemonDetailUseCase) : super(PokemonDetailInitial()) {
    on<FetchPokemonDetail>((event, emit) async {
      emit(PokemonDetailLoading());
      try {
        final response = await pokemonDetailUseCase(event.name);

        emit(PokemonDetailSuccess(response));
      } catch (e) {
        emit(PokemonDetailFailure(e.toString()));
      }
    });
  }
}
