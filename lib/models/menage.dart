// Statut possible d'un ménage bénéficiaire
enum StatutMenage { actif, suspendu, sorti }

class Menage {
  final String id;
  String chefMenage;
  int nbPersonnes;
  String commune;
  String departement;
  int montantTrimestriel; // en FCFA
  DateTime dateInscription;
  StatutMenage statut;

  Menage({
    required this.id,
    required this.chefMenage,
    required this.nbPersonnes,
    required this.commune,
    required this.departement,
    required this.montantTrimestriel,
    required this.dateInscription,
    this.statut = StatutMenage.actif,
  });

  // Calcule le montant moyen par personne dans le ménage
  double montantMoyenParPersonne() {
    return montantTrimestriel / nbPersonnes;
  }

  // Calcule le total des allocations sur une année (4 trimestres)
  int totalAllocationAnnuelle() {
    return montantTrimestriel * 4;
  }

  // Retourne les initiales du chef de ménage (pour l'avatar)
  String initiales() {
    final parties = chefMenage.trim().split(' ');
    if (parties.length >= 2) {
      return '${parties[0][0]}${parties[1][0]}'.toUpperCase();
    }
    return chefMenage.substring(0, 2).toUpperCase();
  }
}

// Map des communes et leurs départements — Région de Thiès
const Map<String, String> communesDepartements = {
  'Thiès-Nord': 'Thiès',
  'Thiès-Est': 'Thiès',
  'Mbour': 'Mbour',
  'Tivaouane': 'Tivaouane',
  'Khombole': 'Thiès',
};
