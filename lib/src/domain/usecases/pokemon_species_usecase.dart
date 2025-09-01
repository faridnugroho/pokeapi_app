import 'package:pokeapi_app/src/data/repositories/pokemon_species_repository.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_species_model.dart';

class PokemonSpeciesUseCase {
  final PokemonSpeciesRepository pokemonSpeciesRepository;

  PokemonSpeciesUseCase(this.pokemonSpeciesRepository);

  Future<PokemonSpeciesModel> call(String name) async {
    return await pokemonSpeciesRepository.fetchPokemonSpecies(name);
  }
}
