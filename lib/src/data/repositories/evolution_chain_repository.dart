import 'package:pokeapi_app/src/data/network/http_config.dart';
import 'package:pokeapi_app/src/domain/entities/evolution_chain_model.dart';

class EvolutionChainRepository {
  Future<EvolutionChainModel> fetchByUrl(String url) async {
    try {
      final response = await HttpConfig.dio.getUri(Uri.parse(url));
      return EvolutionChainModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
