import 'package:pokeapi_app/src/data/repositories/pokemons_repository.dart';
import 'package:pokeapi_app/src/domain/entities/pokemons_model.dart';

class PokemonsUseCase {
  final PokemonsRepository repository;

  PokemonsUseCase({required this.repository});

  Future<PokemonsModel> call() async {
    return await repository.fetchPokemons();
  }
}
