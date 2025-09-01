import 'package:flutter/material.dart';
import 'package:pokeapi_app/src/data/repositories/pokemon_detail_repository.dart';
import 'package:pokeapi_app/src/data/repositories/pokemon_species_repository.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_detail_model.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_species_model.dart' as sp;
import 'package:pokeapi_app/src/utils/color_helper.dart';

class PokemonDetailPage extends StatelessWidget {
  final String name;
  final int id;

  const PokemonDetailPage({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<sp.PokemonSpeciesModel>(
          future: PokemonSpeciesRepository().fetchPokemonSpecies(name),
          builder: (context, snapshotSpecies) {
            if (snapshotSpecies.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshotSpecies.hasError || !snapshotSpecies.hasData) {
              return const Center(child: Text("Failed to load species"));
            }

            final species = snapshotSpecies.data!;
            final gradient = species.color?.name.toPokemonGradient();

            return FutureBuilder<PokemonDetailModel>(
              future: PokemonDetailRepository().fetchPokemonDetail(name),
              builder: (context, snapshotDetail) {
                if (snapshotDetail.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshotDetail.hasError || !snapshotDetail.hasData) {
                  return const Center(child: Text("Failed to load detail"));
                }

                final data = snapshotDetail.data!;
                final types = data.types?.map((t) => t.type?.name ?? "").toList() ?? [];
                final weight = (data.weight ?? 0) / 10.0;
                final height = (data.height ?? 0) * 10.0;
                final abilities = data.abilities?.map((a) => a.ability?.name ?? "").join(", ") ?? "";

                return Stack(
                  children: [
                    Container(decoration: BoxDecoration(gradient: gradient)),

                    SafeArea(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name[0].toUpperCase() + name.substring(1),
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children:
                                          types
                                              .map(
                                                (t) => Container(
                                                  margin: const EdgeInsets.only(right: 8),
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white24,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: Text(
                                                    t[0].toUpperCase() + t.substring(1),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "#${id.toString().padLeft(3, '0')}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 160), // TURUNKAN card putih
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 30),
                                const TabBar(
                                  tabAlignment: TabAlignment.center,
                                  indicatorColor: Colors.blue,
                                  labelColor: Colors.black,
                                  tabs: [
                                    Tab(text: "About"),
                                    Tab(text: "Base Stats"),
                                    Tab(text: "Evolution"),
                                    Tab(text: "Moves"),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _AboutTab(height: height, weight: weight, abilities: abilities),
                                      _BaseStatsTab(
                                        stats: data.stats ?? [],
                                        accent: (gradient?.colors.first) ?? Colors.teal, // selaraskan warna
                                      ),
                                      const Center(child: Text("Evolution Tab")),
                                      const Center(child: Text("Moves Tab")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Positioned(
                      top: 145, // Naikkan gambar agar tidak nutup tab bar
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.network(
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$id.png",
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  final double height;
  final double weight;
  final String abilities;

  const _AboutTab({required this.height, required this.weight, required this.abilities});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
        children: [
          const TableRow(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Species", style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Seed")),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Height", style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text("${height.toStringAsFixed(1)} cm")),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Weight", style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text("${weight.toStringAsFixed(1)} kg")),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Abilities", style: TextStyle(color: Colors.grey)),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(abilities)),
            ],
          ),
        ],
      ),
    );
  }
}

class _BaseStatsTab extends StatelessWidget {
  final List<Stat> stats;
  final Color accent;

  const _BaseStatsTab({required this.stats, required this.accent});

  // Ambil nilai base_stat utk key tertentu (hp, attack, dst)
  int _val(String key) {
    final s = stats.firstWhere((e) => e.stat?.name == key, orElse: () => Stat());
    return s.baseStat ?? 0;
  }

  Widget _row(BuildContext context, String label, int value) {
    // Normalisasi (max base stat umumnya ~255)
    final double pct = (value.clamp(0, 255)) / 255.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _row(context, 'HP', _val('hp')),
          _row(context, 'Attack', _val('attack')),
          _row(context, 'Defense', _val('defense')),
          _row(context, 'Sp. Atk', _val('special-attack')),
          _row(context, 'Sp. Def', _val('special-defense')),
          _row(context, 'Speed', _val('speed')),
        ],
      ),
    );
  }
}
