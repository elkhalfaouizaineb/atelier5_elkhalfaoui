import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AjoutProduitPage extends StatelessWidget {
  final TextEditingController designationController = TextEditingController();
  final TextEditingController marqueController = TextEditingController();
  final TextEditingController categorieController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  final TextEditingController photoUrlController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un produit'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField('Désignation', designationController),
            SizedBox(height: 16.0),
            _buildTextField('Marque', marqueController),
            SizedBox(height: 16.0),
            _buildTextField('Catégorie', categorieController),
            SizedBox(height: 16.0),
            _buildTextField('Prix', prixController, TextInputType.number),
            SizedBox(height: 32.0),
             _buildTextField('PhotoUrl', photoUrlController),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                ajouterProduit();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Ajouter le produit',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  void ajouterProduit() {
    db.collection('produits').add({
      'designation': designationController.text,
      'marque': marqueController.text,
      'categorie': categorieController.text,
      'prix': double.parse(prixController.text),
      // Add other fields as needed
    });
  }
}
