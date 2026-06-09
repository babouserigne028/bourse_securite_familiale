import 'package:flutter/material.dart';
import '../models/menage.dart';
import '../data/sample_data.dart';
import '../widgets/menage_card.dart';

class ListeMenagesScreen extends StatefulWidget {
  const ListeMenagesScreen({super.key});

  @override
  State<ListeMenagesScreen> createState() => _ListeMenagesScreenState();
}

class _ListeMenagesScreenState extends State<ListeMenagesScreen> {
  final List<Menage> _menages = List.from(menagesInitiaux);
  List<Menage> _menagesFiltres = [];
  final TextEditingController _rechercheController = TextEditingController();
  bool _triParPersonnes = false;

  @override
  void initState() {
    super.initState();
    _menagesFiltres = List.from(_menages);
  }

  @override
  void dispose() {
    _rechercheController.dispose();
    super.dispose();
  }

  // Normalise une chaîne : minuscules + suppression des accents
  String _normaliser(String s) {
    return s.toLowerCase()
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[àâ]'), 'a')
        .replaceAll(RegExp(r'[ùû]'), 'u')
        .replaceAll(RegExp(r'[îï]'), 'i')
        .replaceAll(RegExp(r'[ôö]'), 'o')
        .replaceAll('ç', 'c');
  }

  // Recherche par commune avec mise à jour instantanée (setState)
  void _filtrerParCommune(String query) {
    setState(() {
      _menagesFiltres = _menages
          .where((m) => _normaliser(m.commune).contains(_normaliser(query)))
          .toList();
      if (_triParPersonnes) {
        _menagesFiltres.sort((a, b) => a.nbPersonnes.compareTo(b.nbPersonnes));
      }
    });
  }

  // Tri par nombre de personnes (setState)
  void _toggleTri() {
    setState(() {
      _triParPersonnes = !_triParPersonnes;
      if (_triParPersonnes) {
        _menagesFiltres.sort((a, b) => a.nbPersonnes.compareTo(b.nbPersonnes));
      } else {
        _filtrerParCommune(_rechercheController.text);
      }
    });
  }

  // Regroupe la liste filtrée par commune
  Map<String, List<Menage>> _grouperParCommune() {
    final Map<String, List<Menage>> groupes = {};
    for (final menage in _menagesFiltres) {
      groupes.putIfAbsent(menage.commune, () => []).add(menage);
    }
    return groupes;
  }

  Future<void> _ouvrirFormulaire([Menage? menage]) async {
    final result = await Navigator.pushNamed(
      context,
      '/formulaire',
      arguments: menage,
    );
    if (result != null && result is Menage) {
      setState(() {
        if (menage == null) {
          _menages.add(result);
        } else {
          final index = _menages.indexWhere((m) => m.id == result.id);
          if (index != -1) _menages[index] = result;
        }
        _filtrerParCommune(_rechercheController.text);
      });
    }
  }

  Future<void> _ouvrirDetail(Menage menage) async {
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: menage,
    );
    if (result == 'delete') {
      setState(() {
        _menages.removeWhere((m) => m.id == menage.id);
        _filtrerParCommune(_rechercheController.text);
      });
    } else if (result is Menage) {
      setState(() {
        final index = _menages.indexWhere((m) => m.id == result.id);
        if (index != -1) _menages[index] = result;
        _filtrerParCommune(_rechercheController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupes = _grouperParCommune();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bourse Sécurité Familiale',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _triParPersonnes ? Icons.sort : Icons.sort_outlined,
              color: Colors.white,
            ),
            tooltip: 'Trier par nombre de personnes',
            onPressed: _toggleTri,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'À propos',
            onPressed: () => Navigator.pushNamed(context, '/apropos'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche — design Stitch
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _rechercheController,
              onChanged: _filtrerParCommune,
              decoration: InputDecoration(
                hintText: 'Rechercher par commune...',
                hintStyle: const TextStyle(color: Color(0xFF40493D)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF40493D)),
                filled: true,
                fillColor: const Color(0xFFA5D6A7).withValues(alpha: 0.2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: Color(0xFF0D631B), width: 1.5),
                ),
              ),
            ),
          ),

          // Résumé + chip tri
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_menagesFiltres.length} ménage(s)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF171D14),
                  ),
                ),
                if (_triParPersonnes)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D631B),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.filter_list,
                            size: 13, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Trié par nb personnes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Liste groupée par commune
          Expanded(
            child: _menagesFiltres.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun ménage trouvé',
                      style: TextStyle(color: Color(0xFF40493D)),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: groupes.keys.length,
                    itemBuilder: (context, index) {
                      final commune = groupes.keys.elementAt(index);
                      final liste = groupes[commune]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // En-tête groupe commune — design Stitch
                          Container(
                            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$commune — ${liste.length} ménage(s)',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color(0xFF0D631B),
                              ),
                            ),
                          ),
                          ...liste.map(
                            (m) => MenageCard(
                              menage: m,
                              onTap: () => _ouvrirDetail(m),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ouvrirFormulaire(),
        tooltip: 'Ajouter un ménage',
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
