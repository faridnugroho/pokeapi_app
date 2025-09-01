import 'package:pokeapi_app/src/data/network/http_config.dart';
import 'package:pokeapi_app/src/domain/entities/pokemons_model.dart';

class PokemonsRepository {
  Future<PokemonsModel> fetchPokemons() async {
    try {
      final response = await HttpConfig.dio.get('/pokemon');
      final data = PokemonsModel.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
