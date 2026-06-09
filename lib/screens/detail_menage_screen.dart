import 'package:flutter/material.dart';
import '../models/menage.dart';

// Écran de détail — StatelessWidget, affichage pur
class DetailMenageScreen extends StatelessWidget {
  const DetailMenageScreen({super.key});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatMontant(int montant) {
    final s = montant.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  String _libelleStatut(StatutMenage statut) {
    switch (statut) {
      case StatutMenage.actif:     return 'Actif';
      case StatutMenage.suspendu:  return 'Suspendu';
      case StatutMenage.sorti:     return 'Sorti';
    }
  }

  Color _couleurStatut(StatutMenage statut) {
    switch (statut) {
      case StatutMenage.actif:     return const Color(0xFF0D631B);
      case StatutMenage.suspendu:  return const Color(0xFFEF6C00);
      case StatutMenage.sorti:     return const Color(0xFF757575);
    }
  }

  Future<void> _confirmerSuppression(BuildContext context, Menage menage) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce ménage ?'),
        content: Text(
          'Voulez-vous vraiment supprimer le ménage de ${menage.chefMenage} ? '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirme == true && context.mounted) {
      Navigator.pop(context, 'delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Réception de l'argument — passage d'argument entre écrans
    final menage = ModalRoute.of(context)!.settings.arguments as Menage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche ménage',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            tooltip: 'Modifier',
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/formulaire',
                arguments: menage,
              );
              if (result is Menage && context.mounted) {
                Navigator.pop(context, result);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Section profil — dégradé vert subtil comme Stitch
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0D631B).withValues(alpha: 0.08),
                    const Color(0xFFF5FCED),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Avatar grande taille
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBDEFBE),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      menage.initiales(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF426E47),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    menage.chefMenage,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171D14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Badge statut — fond solide
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: _couleurStatut(menage.statut),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          _libelleStatut(menage.statut),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Liste d'informations — icônes dans carré vert arrondi (design Stitch)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFBFCABA).withValues(alpha: 0.4),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _infoRow(Icons.location_on, 'Commune', menage.commune),
                      _divider(),
                      _infoRow(Icons.map, 'Département', menage.departement),
                      _divider(),
                      _infoRow(Icons.groups, 'Nombre de personnes',
                          '${menage.nbPersonnes}'),
                      _divider(),
                      _infoRow(Icons.calendar_month, 'Date d\'inscription',
                          _formatDate(menage.dateInscription)),
                      _divider(),
                      _infoRow(Icons.payments, 'Allocation trimestrielle',
                          '${_formatMontant(menage.montantTrimestriel)} FCFA',
                          valueColor: const Color(0xFF2E7D32)),
                    ],
                  ),
                ),
              ),
            ),

            // Tuiles de calcul — design Stitch (#F1F8E9 + bordure verte)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _calculTile(
                      'MONTANT MOYEN / PERSONNE',
                      '${_formatMontant(menage.montantMoyenParPersonne().round())} FCFA',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _calculTile(
                      'TOTAL ALLOCATION ANNUELLE',
                      '${_formatMontant(menage.totalAllocationAnnuelle())} FCFA',
                    ),
                  ),
                ],
              ),
            ),

            // Bouton supprimer
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.delete, color: Color(0xFFBA1A1A)),
                  label: const Text(
                    'Supprimer ce ménage',
                    style: TextStyle(
                        color: Color(0xFFBA1A1A),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFBA1A1A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _confirmerSuppression(context, menage),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFEFF6E7));

  Widget _infoRow(IconData icon, String label, String valeur,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Icône dans carré vert arrondi — design Stitch
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F0E1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: const Color(0xFF0D631B), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Color(0xFF40493D), fontSize: 11)),
              Text(
                valeur,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: valueColor ?? const Color(0xFF171D14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _calculTile(String label, String valeur) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0D631B).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF40493D),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            valeur,
            style: const TextStyle(
              color: Color(0xFF0D631B),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
