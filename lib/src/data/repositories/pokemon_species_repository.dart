import 'package:pokeapi_app/src/data/network/http_config.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_species_model.dart';

class PokemonSpeciesRepository {
  Future<PokemonSpeciesModel> fetchPokemonSpecies(String name) async {
    try {
      final response = await HttpConfig.dio.get('/pokemon-species/$name');
      final data = PokemonSpeciesModel.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
