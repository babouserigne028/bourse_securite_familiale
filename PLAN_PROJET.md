# Bourse de Sécurité Familiale — Plan du projet Flutter
**Étudiant :** Serigne Abdoulaye Babou  
**Module :** Développement Multiplateforme  
**ODD :** 1 — Pas de pauvreté  
**Date de planification :** Juin 2026

---

## 1. Contexte du projet

Un programme social verse une allocation trimestrielle aux ménages vulnérables.  
L'application Flutter permet de tenir le registre de ces ménages bénéficiaires.

---

## 2. Données de l'application

### Modèle `Menage`

| Champ | Type Dart | Description |
|---|---|---|
| `id` | `String` | Identifiant unique (DateTime.now().millisecondsSinceEpoch.toString()) |
| `chefMenage` | `String` | Nom et prénom du chef de ménage |
| `nbPersonnes` | `int` | Nombre de personnes dans le ménage |
| `commune` | `String` | Commune parmi les 5 de la région de Thiès |
| `departement` | `String` | Département (déduit via Map depuis la commune) |
| `montantTrimestriel` | `int` | Allocation en FCFA |
| `dateInscription` | `DateTime` | Date d'enregistrement dans le registre |
| `statut` | `StatutMenage` | enum : actif / suspendu / sorti |

### Enum `StatutMenage`
```dart
enum StatutMenage { actif, suspendu, sorti }
```

### Méthodes de calcul (exigence Dart)
```dart
double montantMoyenParPersonne() => montantTrimestriel / nbPersonnes;
int totalAllocationAnnuelle()    => montantTrimestriel * 4;
```

---

## 3. Les 5 communes réelles — Région de Thiès

| Commune | Département |
|---|---|
| Thiès-Nord | Thiès |
| Thiès-Est | Thiès |
| Mbour | Mbour |
| Tivaouane | Tivaouane |
| Khombole | Thiès |

```dart
const Map<String, String> communesDepartements = {
  'Thiès-Nord' : 'Thiès',
  'Thiès-Est'  : 'Thiès',
  'Mbour'      : 'Mbour',
  'Tivaouane'  : 'Tivaouane',
  'Khombole'   : 'Thiès',
};
```

---

## 4. Données de démo — 10 ménages placeholders

> ⚠️ À remplacer par les données réellement collectées (source + preuves photos datées)

| Chef de ménage | Nb pers. | Commune | Montant (FCFA) | Date | Statut |
|---|---|---|---|---|---|
| Ousmane Diallo | 6 | Thiès-Nord | 75 000 | 15/03/2024 | actif |
| Fatou Ndiaye | 4 | Thiès-Nord | 60 000 | 20/04/2024 | actif |
| Ibrahima Sarr | 8 | Thiès-Est | 90 000 | 10/01/2024 | actif |
| Aminata Fall | 3 | Thiès-Est | 50 000 | 05/06/2024 | suspendu |
| Moussa Diop | 7 | Mbour | 80 000 | 22/02/2024 | actif |
| Rokhaya Sow | 5 | Mbour | 65 000 | 18/07/2024 | actif |
| Abdou Mbaye | 9 | Tivaouane | 95 000 | 01/01/2024 | actif |
| Mariama Cissé | 4 | Tivaouane | 60 000 | 30/08/2024 | sorti |
| Cheikh Lô | 6 | Khombole | 75 000 | 12/05/2024 | actif |
| Ndèye Gueye | 2 | Khombole | 45 000 | 25/09/2024 | actif |

---

## 5. Architecture des écrans

```
Écran 1 — ListeMenagesScreen        (StatefulWidget)
  ├── AppBar : titre + icône À propos
  ├── TextField : recherche par commune (onChanged → setState)
  ├── Bouton tri : par nbPersonnes (setState)
  ├── ListView groupée par commune
  │    └── MenageCard (widget réutilisable) avec Avatar initiales
  └── FloatingActionButton → Écran 3 (ajout, argument = null)

Écran 2 — DetailMenageScreen        (StatelessWidget)
  ├── Reçoit : Menage via ModalRoute.of(context)!.settings.arguments
  ├── Avatar grande taille + initiales
  ├── Tous les champs du ménage
  ├── montantMoyenParPersonne() + totalAllocationAnnuelle() affichés
  ├── Bouton Modifier → Écran 3 (argument = menage existant)
  └── Bouton Supprimer → showDialog AlertDialog → Navigator.pop('delete')

Écran 3 — FormulaireMenageScreen    (StatefulWidget)
  ├── Reçoit : Menage? (null = ajout, non-null = modification)
  ├── Form + GlobalKey<FormState>
  ├── TextFormField : chefMenage (validator: non vide)
  ├── TextFormField : nbPersonnes (validator: entier > 0)
  ├── DropdownButtonFormField : commune (liste des 5)
  ├── TextFormField : montantTrimestriel (validator: entier > 0)
  ├── TextFormField : dateInscription (DatePicker)
  ├── DropdownButtonFormField : statut (enum StatutMenage)
  └── Bouton Enregistrer → validate() → Navigator.pop(menage)

Écran 4 — AProposScreen             (StatelessWidget)
  ├── Nom : Serigne Abdoulaye Babou
  ├── Module : Développement Multiplateforme — DAR 2026
  ├── Thématique : Bourse de Sécurité Familiale — ODD 1
  ├── Source des données : [À REMPLIR après collecte]
  └── Date de collecte : [À REMPLIR après collecte]
```

---

## 6. Routes nommées

```dart
// Dans main.dart
routes: {
  '/'           : (_) => const ListeMenagesScreen(),
  '/detail'     : (_) => const DetailMenageScreen(),
  '/formulaire' : (_) => const FormulaireMenageScreen(),
  '/apropos'    : (_) => const AProposScreen(),
},
```

### Passage d'arguments

```dart
// Écran 1 → Écran 2 (lire un ménage)
Navigator.pushNamed(context, '/detail', arguments: menage);

// Écran 1 → Écran 3 (ajouter)
Navigator.pushNamed(context, '/formulaire', arguments: null);

// Écran 2 → Écran 3 (modifier)
Navigator.pushNamed(context, '/formulaire', arguments: menage);

// Réception dans Écran 2
final menage = ModalRoute.of(context)!.settings.arguments as Menage;

// Réception dans Écran 3
final menage = ModalRoute.of(context)!.settings.arguments as Menage?;

// Retour Écran 3 → Écran 1 (avec le nouveau ménage)
Navigator.pop(context, nouveauMenage);

// Retour Écran 2 → Écran 1 (suppression)
Navigator.pop(context, 'delete');
```

---

## 7. Gestion de l'état (State Management)

- La `List<Menage> _menages` vit dans `_ListeMenagesScreenState`
- Après retour de l'Écran 3 : `setState(() { _menages.add(result) })`
- Après suppression depuis Écran 2 : `setState(() { _menages.removeWhere(...) })`
- Recherche : `setState(() { _filtres = _menages.where((m) => m.commune.toLowerCase().contains(query)).toList() })`
- Tri : `setState(() { _filtres.sort((a, b) => a.nbPersonnes.compareTo(b.nbPersonnes)) })`

---

## 8. Thème visuel — ODD 1 Pas de pauvreté

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2E7D32)),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2E7D32),
    foregroundColor: Colors.white,
  ),
)
```

- Couleur principale : `#2E7D32` (vert foncé ODD 1)
- Avatar initiales : fond `#A5D6A7` (vert clair), texte `#1B5E20`
- En-têtes de groupe commune : bandeau `#E8F5E9`
- Badge statut : vert (actif), orange (suspendu), gris (sorti)

---

## 9. Widget réutilisable — `MenageCard`

```
MenageCard (StatelessWidget)
  Paramètres : menage, onTap
  Contenu :
    - CircleAvatar avec initiales du chefMenage
    - Nom du chef + commune + nbPersonnes
    - Montant trimestriel formaté
    - Badge statut coloré
```

---

## 10. Structure des fichiers

```
bourse_securite_familiale/
└── lib/
    ├── main.dart
    ├── models/
    │   └── menage.dart              ← classe + enum + méthodes calcul
    ├── data/
    │   └── sample_data.dart         ← 10 ménages + Map communes
    ├── widgets/
    │   └── menage_card.dart         ← StatelessWidget réutilisable
    └── screens/
        ├── liste_menages_screen.dart
        ├── detail_menage_screen.dart
        ├── formulaire_menage_screen.dart
        └── a_propos_screen.dart
```

---

## 11. Grille des 5 compétences Flutter

| Compétence | Implémentation | Fichier |
|---|---|---|
| **Dart** | Classe Menage, enum StatutMenage, List\<Menage\>, Map communes, 2 méthodes calcul, null safety | `menage.dart` |
| **Stateless/Stateful** | StatefulWidget : Liste + Formulaire / StatelessWidget : Détail + APropos + MenageCard | tous les screens |
| **UI personnalisée** | ThemeData vert ODD1 + MenageCard réutilisable + Avatar initiales + groupement | `main.dart` + `menage_card.dart` |
| **CRUD complet** | Create (form validation) + Read (liste+détail) + Update (form pré-rempli) + Delete (dialog) | `formulaire` + `detail` |
| **Routage** | 4 routes nommées + passage argument Menage entre écrans | `main.dart` + tous |

---

## 12. Barème — stratégie de points

| Critère | Pts | Priorité |
|---|---|---|
| Rapport individuel | 4 pts | ⭐⭐⭐ Citer fichier + ligne exacte |
| CRUD complet et correct | 3 pts | ⭐⭐⭐ Les 4 opérations sans bug |
| Vidéo présentation | 3 pts | ⭐⭐⭐ Démo fluide + expliquer concepts |
| Vidéo live coding | 3 pts | ⭐⭐⭐ Recoder les 3 fonctions en 5 min |
| Routage | 2 pts | ⭐⭐ 4 routes + argument visible |
| Stateful/Stateless + Dart | 2 pts | ⭐⭐ enum, méthodes, setState justifié |
| UI personnalisée | 2 pts | ⭐⭐ ThemeData + MenageCard |
| Données réelles + À propos | 1 pt | ⭐ Source réelle citée |
| **TOTAL** | **20 pts** | |

---

## 13. Live coding — script des 5 minutes

### Fonction 1 — Création + Suppression (~2 min)
- Montrer `GlobalKey<FormState>` + `validator:`
- Montrer `setState(() { _menages.add(m) })`
- Montrer `showDialog()` + `AlertDialog` + `Navigator.pop('delete')`

### Fonction 2 — Recherche par commune (~1 min 30)
- Montrer `TextField` + `onChanged:`
- Montrer `setState(() { _filtres = _menages.where(...).toList() })`

### Fonction 3 — Tri + Passage d'arguments (~1 min 30)
- Montrer `list.sort((a, b) => a.nbPersonnes.compareTo(b.nbPersonnes))`
- Montrer `Navigator.pushNamed(context, '/detail', arguments: menage)`
- Montrer `ModalRoute.of(context)!.settings.arguments as Menage`

---

## 14. Livrables — checklist

- [ ] Code source sur dépôt Git (GitHub/GitLab) avec commits réguliers
- [ ] Écran "À propos" dans l'app (nom + source + date collecte)
- [ ] Rapport individuel 2-3 pages (modèle section 5)
- [ ] Vidéo 10 minutes (démo 5 min + live coding 5 min)
- [ ] Jeu de données réel collecté + preuves photos datées

---

## 15. À faire AVANT de coder

- [ ] Choisir GitHub ou GitLab et créer le dépôt
- [ ] Collecter les données réelles (source officielle PNBSF ou terrain)
- [ ] Prendre les photos datées comme preuve de collecte
- [ ] Remplir la source et la date dans l'écran À propos
