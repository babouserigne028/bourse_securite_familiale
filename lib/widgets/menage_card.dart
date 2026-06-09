import 'package:flutter/material.dart';
import '../models/menage.dart';

// Widget réutilisable — design Stitch
class MenageCard extends StatelessWidget {
  final Menage menage;
  final VoidCallback onTap;

  const MenageCard({
    super.key,
    required this.menage,
    required this.onTap,
  });

  Color _couleurStatut() {
    switch (menage.statut) {
      case StatutMenage.actif:
        return const Color(0xFF0D631B);
      case StatutMenage.suspendu:
        return const Color(0xFFEF6C00);
      case StatutMenage.sorti:
        return const Color(0xFF757575);
    }
  }

  String _libelleStatut() {
    switch (menage.statut) {
      case StatutMenage.actif:    return 'Actif';
      case StatutMenage.suspendu: return 'Suspendu';
      case StatutMenage.sorti:    return 'Sorti';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFBFCABA).withValues(alpha: 0.4),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D631B).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar avec initiales
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFA5D6A7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                menage.initiales(),
                style: const TextStyle(
                  color: Color(0xFF0D631B),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Nom + commune
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          menage.chefMenage,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF171D14),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatMontant(menage.montantTrimestriel)} FCFA',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF0D631B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${menage.commune} • ${menage.nbPersonnes} pers.',
                        style: const TextStyle(
                          color: Color(0xFF40493D),
                          fontSize: 13,
                        ),
                      ),
                      // Badge statut — fond solide selon Stitch
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _couleurStatut(),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _libelleStatut(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
