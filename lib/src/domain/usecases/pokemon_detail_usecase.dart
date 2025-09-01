import 'package:pokeapi_app/src/data/repositories/pokemon_detail_repository.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_detail_model.dart';

class PokemonDetailUseCase {
  final PokemonDetailRepository pokemonDetailRepository;

  PokemonDetailUseCase(this.pokemonDetailRepository);

  Future<PokemonDetailModel> call(String name) async {
    return await pokemonDetailRepository.fetchPokemonDetail(name);
  }
}
