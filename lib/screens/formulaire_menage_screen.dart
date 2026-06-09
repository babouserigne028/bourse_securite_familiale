import 'package:flutter/material.dart';
import '../models/menage.dart';

class FormulaireMenageScreen extends StatefulWidget {
  const FormulaireMenageScreen({super.key});

  @override
  State<FormulaireMenageScreen> createState() => _FormulaireMenageScreenState();
}

class _FormulaireMenageScreenState extends State<FormulaireMenageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _chefController = TextEditingController();
  final _nbPersonnesController = TextEditingController();
  final _montantController = TextEditingController();

  String? _communeSelectionnee;
  DateTime? _dateInscription;
  StatutMenage _statut = StatutMenage.actif;

  bool _estModification = false;
  late String _idMenage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final menage = ModalRoute.of(context)?.settings.arguments as Menage?;
    if (menage != null && !_estModification) {
      _estModification = true;
      _idMenage = menage.id;
      _chefController.text = menage.chefMenage;
      _nbPersonnesController.text = menage.nbPersonnes.toString();
      _montantController.text = menage.montantTrimestriel.toString();
      _communeSelectionnee = menage.commune;
      _dateInscription = menage.dateInscription;
      _statut = menage.statut;
    } else if (!_estModification) {
      _idMenage = DateTime.now().millisecondsSinceEpoch.toString();
      _dateInscription = DateTime.now();
    }
  }

  @override
  void dispose() {
    _chefController.dispose();
    _nbPersonnesController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _choisirDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dateInscription ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _dateInscription = date);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _enregistrer() {
    if (_formKey.currentState!.validate() && _dateInscription != null) {
      final menage = Menage(
        id: _idMenage,
        chefMenage: _chefController.text.trim(),
        nbPersonnes: int.parse(_nbPersonnesController.text),
        commune: _communeSelectionnee!,
        departement: communesDepartements[_communeSelectionnee!]!,
        montantTrimestriel: int.parse(_montantController.text),
        dateInscription: _dateInscription!,
        statut: _statut,
      );
      Navigator.pop(context, menage);
    } else if (_dateInscription == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une date')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _estModification ? 'Modifier le ménage' : 'Nouveau ménage',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chef de ménage
              _labelChamp('Chef de ménage'),
              _champTexte(
                controller: _chefController,
                hint: 'Nom complet du responsable',
                icon: Icons.person,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Ce champ est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Nb personnes + Commune côte à côte
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _labelChamp('Nombre de personnes'),
                        _champTexte(
                          controller: _nbPersonnesController,
                          hint: 'Ex: 5',
                          icon: Icons.group,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Obligatoire';
                            }
                            final n = int.tryParse(val);
                            if (n == null || n <= 0) return 'Entier > 0';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _labelChamp('Commune'),
                        _champDropdownCommune(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Montant trimestriel
              _labelChamp('Montant trimestriel (FCFA)'),
              _champTexte(
                controller: _montantController,
                hint: 'Ex: 25000',
                icon: Icons.payments,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Ce champ est obligatoire';
                  final n = int.tryParse(val);
                  if (n == null || n <= 0) return 'Entrez un montant valide';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date d'inscription
              _labelChamp("Date d'inscription"),
              GestureDetector(
                onTap: _choisirDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFCABA)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color(0xFF707A6C), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _dateInscription != null
                            ? _formatDate(_dateInscription!)
                            : 'Sélectionner une date',
                        style: TextStyle(
                          color: _dateInscription != null
                              ? const Color(0xFF171D14)
                              : const Color(0xFF707A6C),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Statut
              _labelChamp('Statut'),
              _champDropdownStatut(),
              const SizedBox(height: 24),

              // Encart info — design Stitch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6E7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFBFCABA).withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D631B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.info,
                          color: Color(0xFF0D631B), size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Validation requise',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15)),
                          Text(
                            "L'ajout nécessite une vérification par le superviseur régional.",
                            style: TextStyle(
                                color: Color(0xFF40493D), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      // Bouton fixe en bas — design Stitch
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFF5FCED),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: Text(
                _estModification
                    ? 'Enregistrer les modifications'
                    : 'Ajouter le ménage',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _enregistrer,
            ),
          ),
        ),
      ),
    );
  }

  Widget _labelChamp(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF40493D),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _champTexte({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF707A6C), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF707A6C), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF0D631B), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _champDropdownCommune() {
    return DropdownButtonFormField<String>(
      initialValue: _communeSelectionnee,
      decoration: InputDecoration(
        hintText: 'Sélectionner',
        hintStyle: const TextStyle(color: Color(0xFF707A6C), fontSize: 14),
        prefixIcon:
            const Icon(Icons.location_on, color: Color(0xFF707A6C), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF0D631B), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: communesDepartements.keys.map((commune) {
        return DropdownMenuItem(value: commune, child: Text(commune));
      }).toList(),
      onChanged: (val) => setState(() => _communeSelectionnee = val),
      validator: (val) =>
          val == null ? 'Obligatoire' : null,
    );
  }

  Widget _champDropdownStatut() {
    return DropdownButtonFormField<StatutMenage>(
      initialValue: _statut,
      decoration: InputDecoration(
        prefixIcon:
            const Icon(Icons.flag, color: Color(0xFF707A6C), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFBFCABA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF0D631B), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: const [
        DropdownMenuItem(value: StatutMenage.actif, child: Text('Actif')),
        DropdownMenuItem(
            value: StatutMenage.suspendu, child: Text('Suspendu')),
        DropdownMenuItem(value: StatutMenage.sorti, child: Text('Sorti')),
      ],
      onChanged: (val) => setState(() => _statut = val!),
    );
  }
}
