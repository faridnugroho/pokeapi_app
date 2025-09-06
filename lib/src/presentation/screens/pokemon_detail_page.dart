import 'package:flutter/material.dart';
import 'package:pokeapi_app/src/data/repositories/pokemon_detail_repository.dart';
import 'package:pokeapi_app/src/data/repositories/pokemon_species_repository.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_detail_model.dart';
import 'package:pokeapi_app/src/domain/entities/pokemon_species_model.dart' as sp;
import 'package:pokeapi_app/src/utils/color_helper.dart';
import 'package:pokeapi_app/src/domain/entities/evolution_chain_model.dart' as evo;
import 'package:pokeapi_app/src/data/repositories/evolution_chain_repository.dart';

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
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    splashFactory: InkRipple.splashFactory,
                                    highlightColor: ((gradient?.colors.first) ?? Colors.teal).withValues(alpha: 0.1),
                                    splashColor: ((gradient?.colors.first) ?? Colors.teal).withValues(alpha: 0.2),
                                  ),
                                  child: TabBar(
                                    tabAlignment: TabAlignment.center,
                                    indicatorColor: (gradient?.colors.first) ?? Colors.teal,
                                    labelColor: Colors.black,
                                    unselectedLabelColor: Colors.grey,
                                    tabs: const [
                                      Tab(text: "About"),
                                      Tab(text: "Base Stats"),
                                      Tab(text: "Evolution"),
                                      Tab(text: "Moves"),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      _AboutTab(height: height, weight: weight, abilities: abilities),
                                      _BaseStatsTab(
                                        stats: data.stats ?? [],
                                        accent: (gradient?.colors.first) ?? Colors.teal, // selaraskan warna
                                      ),
                                      _EvolutionTab(species: species),
                                      _MovesTab(
                                        moves: data.moves ?? [],
                                        accent: (gradient?.colors.first) ?? Colors.teal,
                                      ),
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

class _EvolutionTab extends StatelessWidget {
  final sp.PokemonSpeciesModel species;

  const _EvolutionTab({required this.species});

  Future<List<_EvolutionNode>> _buildEvolutionNodes() async {
    final chainUrl = species.evolutionChain?.url;
    if (chainUrl == null || chainUrl.isEmpty) return [];

    final repo = EvolutionChainRepository();
    final evoData = await repo.fetchByUrl(chainUrl);

    final List<_EvolutionNode> result = [];

    void traverse(evo.ChainLink? link) {
      if (link == null || link.species?.name == null) return;
      final current = _EvolutionNode(
        name: link.species!.name!,
        minLevel:
            link.evolutionDetails != null && link.evolutionDetails!.isNotEmpty
                ? link.evolutionDetails!.first.minLevel
                : null,
        trigger:
            link.evolutionDetails != null && link.evolutionDetails!.isNotEmpty
                ? link.evolutionDetails!.first.trigger?.name
                : null,
      );
      result.add(current);
      if (link.evolvesTo != null) {
        for (final child in link.evolvesTo!) {
          traverse(child);
        }
      }
    }

    traverse(evoData.chain);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_EvolutionNode>>(
      future: _buildEvolutionNodes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load evolution'));
        }
        final nodes = snapshot.data ?? [];
        if (nodes.isEmpty) {
          return const Center(child: Text('No evolution data'));
        }

        // Vertical list of evolution cards with down arrows
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: nodes.length,
          separatorBuilder:
              (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(child: Icon(Icons.arrow_downward, color: Colors.black54)),
              ),
          itemBuilder: (context, index) {
            return _EvolutionCard(node: nodes[index]);
          },
        );
      },
    );
  }
}

class _EvolutionNode {
  final String name;
  final int? minLevel;
  final String? trigger;

  _EvolutionNode({required this.name, this.minLevel, this.trigger});
}

class _EvolutionCard extends StatelessWidget {
  final _EvolutionNode node;
  const _EvolutionCard({required this.node});

  @override
  Widget build(BuildContext context) {
    final displayName = node.name[0].toUpperCase() + node.name.substring(1);
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.white,
            child: Image.network(
              "https://img.pokemondb.net/sprites/home/normal/${node.name}.png",
              height: 56,
              errorBuilder: (c, e, s) => const Icon(Icons.catching_pokemon),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                if (node.minLevel != null || (node.trigger ?? '').isNotEmpty)
                  Text(
                    [
                      if (node.minLevel != null) "Lvl ${node.minLevel}",
                      if ((node.trigger ?? '').isNotEmpty) node.trigger!,
                    ].join(' • '),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovesTab extends StatefulWidget {
  final List<Move> moves;
  final Color accent;

  const _MovesTab({required this.moves, required this.accent});

  @override
  State<_MovesTab> createState() => _MovesTabState();
}

class _MovesTabState extends State<_MovesTab> {
  String? _selectedMethod; // null = All
  // Only filter by method

  List<_MoveRow> _buildRows() {
    final List<_MoveRow> rows = [];
    for (final m in widget.moves) {
      final moveName = m.move?.name ?? '';
      final details = m.versionGroupDetails ?? [];
      for (final d in details) {
        final method = d.moveLearnMethod?.name ?? '';
        final version = d.versionGroup?.name ?? '';
        rows.add(_MoveRow(moveName: moveName, method: method, versionGroup: version, level: d.levelLearnedAt ?? 0));
      }
    }

    // Deduplicate by moveName+method+versionGroup
    final seen = <String>{};
    final deduped = <_MoveRow>[];
    for (final r in rows) {
      final key = '${r.moveName}|${r.method}|${r.versionGroup}';
      if (seen.add(key)) deduped.add(r);
    }

    // Filtering
    final filtered =
        deduped.where((r) {
          final methodOk = _selectedMethod == null || r.method == _selectedMethod;
          return methodOk;
        }).toList();

    // Sort by level asc, then by move name
    filtered.sort((a, b) {
      final lvl = (a.level).compareTo(b.level);
      if (lvl != 0) return lvl;
      return a.moveName.compareTo(b.moveName);
    });
    return filtered;
  }

  List<String> _availableMethods() {
    final set = <String>{};
    for (final m in widget.moves) {
      for (final d in (m.versionGroupDetails ?? [])) {
        final name = d.moveLearnMethod?.name;
        if (name != null && name.isNotEmpty) set.add(name);
      }
    }
    final list = set.toList()..sort();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final methods = _availableMethods();
    final rows = _buildRows();

    return Column(
      children: [
        // Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CustomFilterChip(
                      label: 'All Methods',
                      isSelected: _selectedMethod == null,
                      onTap: () => setState(() => _selectedMethod = null),
                      accentColor: widget.accent,
                    ),
                    const SizedBox(width: 8),
                    for (final m in methods) ...[
                      _CustomFilterChip(
                        label: m.replaceAll('-', ' '),
                        isSelected: _selectedMethod == m,
                        onTap: () => setState(() => _selectedMethod = m),
                        accentColor: widget.accent,
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // List
        Expanded(
          child:
              rows.isEmpty
                  ? const Center(child: Text('No moves'))
                  : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final r = rows[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.moveName[0].toUpperCase() + r.moveName.substring(1),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _Chip(text: r.method.replaceAll('-', ' ')),
                                    _Chip(text: r.versionGroup.replaceAll('-', ' ')),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 64,
                            child: Text(
                              r.level > 0 ? 'Lvl ${r.level}' : '—',
                              textAlign: TextAlign.right,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

class _MoveRow {
  final String moveName;
  final String method;
  final String versionGroup;
  final int level;

  _MoveRow({required this.moveName, required this.method, required this.versionGroup, required this.level});
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

class _CustomFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const _CustomFilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withValues(alpha: 0.8) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? accentColor : Colors.grey.shade300, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
