import 'package:pokeapi_app/src/data/network/http_config.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_detail_model.dart';

class PokemonDetailRepository {
  Future<PokemonDetailModel> fetchPokemonDetail(String name) async {
    try {
      final response = await HttpConfig.dio.get('/pokemon/$name');
      final data = PokemonDetailModel.fromJson(response.data);

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
