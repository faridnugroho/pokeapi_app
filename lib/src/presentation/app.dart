import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokeapi_app/src/data/repositories/pokemon_detail_repository.dart';
import 'package:pokeapi_app/src/data/repositories/pokemon_species_repository.dart';
import 'package:pokeapi_app/src/data/repositories/pokemons_repository.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_detail_model.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_species_model.dart';
import 'package:pokeapi_app/src/domain/usecases/pokemons_usecase.dart';
import 'package:pokeapi_app/src/presentation/bloc/pokemons/pokemons_bloc.dart';
import 'package:pokeapi_app/src/presentation/bloc/pokemons/pokemons_event.dart';
import 'package:pokeapi_app/src/presentation/bloc/pokemons/pokemons_state.dart';
import 'package:pokeapi_app/src/presentation/screens/pokemon_detail_page.dart';
import 'package:pokeapi_app/src/utils/color_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Technical Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(surface: Colors.white, surfaceTint: Colors.transparent),
      ),
      home: BlocProvider(
        create: (context) => PokemonsBloc(PokemonsUseCase(repository: PokemonsRepository()))..add(FetchPokemons()),
        child: const PokedexPage(),
      ),
    );
  }
}

class PokedexPage extends StatelessWidget {
  const PokedexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text('Pokedex', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
      backgroundColor: Colors.white,
      body: BlocBuilder<PokemonsBloc, PokemonsState>(
        builder: (context, state) {
          if (state is PokemonLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PokemonSuccess) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemCount: state.pokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = state.pokemons[index];
                  final id = int.parse((pokemon.url ?? '').split("/")[6]);
                  final imageUrl =
                      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png";

                  return PokemonCard(name: pokemon.name ?? '', id: id, imageUrl: imageUrl);
                },
              ),
            );
          } else if (state is PokemonFailure) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final String name;
  final int id;
  final String imageUrl;

  const PokemonCard({super.key, required this.name, required this.id, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => PokemonDetailPage(name: name, id: id)));
      },
      child: FutureBuilder<PokemonSpeciesModel>(
        future: PokemonSpeciesRepository().fetchPokemonSpecies(name),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("...", style: TextStyle(color: Colors.white70, fontSize: 12));
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Text("unknown", style: TextStyle(color: Colors.white70, fontSize: 12));
          }

          final species = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              gradient: species.color?.name.toPokemonGradient(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name.isNotEmpty ? '${name[0].toUpperCase()}${name.substring(1)}' : '',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      PokemonTypes(name: name),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Image.network(imageUrl, height: 72, width: 72, fit: BoxFit.contain),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PokemonTypes extends StatelessWidget {
  final String name;

  const PokemonTypes({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PokemonDetailModel>(
      future: PokemonDetailRepository().fetchPokemonDetail(name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("...", style: TextStyle(color: Colors.white70, fontSize: 12));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text("unknown", style: TextStyle(color: Colors.white70, fontSize: 12));
        }

        final detail = snapshot.data!;
        final types = detail.types?.map((t) => t.type?.name ?? "").toList() ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              types
                  .map(
                    (t) => Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: Text(
                        t.isNotEmpty ? '${t[0].toUpperCase()}${t.substring(1)}' : '',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}
