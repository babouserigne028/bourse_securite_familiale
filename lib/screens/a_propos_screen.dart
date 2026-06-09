import 'package:flutter/material.dart';

// Écran À propos — StatelessWidget, affichage statique
class AProposScreen extends StatelessWidget {
  const AProposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À propos',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          children: [
            // Logo ODD 1 — design Stitch
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D631B).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ODD 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Pas de\npauvreté',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFCBFFC2),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bourse de Sécurité Familiale',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D631B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Registre des ménages bénéficiaires\nd\'une allocation trimestrielle',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF40493D), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Card infos étudiant — effet glass comme Stitch
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFA5D6A7).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  _ligneInfo('Étudiant', 'Serigne Abdoulaye Babou',
                      isFirst: true),
                  _ligneInfo('Module', 'Développement Multiplateforme'),
                  _ligneInfo('Formation', 'DAR — 2026'),
                  _ligneInfo('ODD', '1 — Pas de pauvreté',
                      valueColor: const Color(0xFF0D631B), isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section source des données
            Row(
              children: [
                const Expanded(
                    child: Divider(color: Color(0xFFBFCABA), thickness: 0.5)),
                const SizedBox(width: 12),
                const Text(
                  'Source des données',
                  style: TextStyle(
                    color: Color(0xFF0D631B),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                    child: Divider(color: Color(0xFFBFCABA), thickness: 0.5)),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6E7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: const Color(0xFFBFCABA).withValues(alpha: 0.3)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ligneAvecIcone(Icons.storage, 'Source',
                      'À REMPLIR — PNBSF / collecte terrain'),
                  const SizedBox(height: 12),
                  _ligneAvecIcone(
                      Icons.location_on, 'Région', 'Thiès, Sénégal'),
                  const SizedBox(height: 12),
                  _ligneAvecIcone(Icons.calendar_today, 'Date de collecte',
                      'À REMPLIR — Juin 2026'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ligneInfo(String label, String valeur,
      {Color? valueColor,
      bool isFirst = false,
      bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: !isLast
            ? const Border(
                bottom:
                    BorderSide(color: Color(0xFFEFF6E7), width: 1))
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF40493D),
                  fontSize: 11,
                  fontWeight: FontWeight.w500)),
          Text(
            valeur,
            style: TextStyle(
              color: valueColor ?? const Color(0xFF171D14),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ligneAvecIcone(IconData icon, String label, String valeur) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0D631B), size: 22),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF40493D), fontSize: 11)),
            Text(valeur,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF171D14))),
          ],
        ),
      ],
    );
  }
}
