import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_species_model.dart';
import 'package:pokeapi_app/src/domain/usecases/pokemon_species_usecase.dart';

part 'pokemon_species_event.dart';
part 'pokemon_species_state.dart';

class PokemonSpeciesBloc extends Bloc<PokemonSpeciesEvent, PokemonSpeciesState> {
  final PokemonSpeciesUseCase pokemonSpeciesUseCase;

  PokemonSpeciesBloc(this.pokemonSpeciesUseCase) : super(PokemonSpeciesInitial()) {
    on<FetchPokemonSpecies>((event, emit) async {
      emit(PokemonSpeciesLoading());
      try {
        final response = await pokemonSpeciesUseCase(event.name);

        emit(PokemonSpeciesSuccess(response));
      } catch (e) {
        rethrow;
      }
    });
  }
}
