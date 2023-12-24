
import 'package:atelier4_z_elkhalfaoui_iir5g2/AjoutProduitPage.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/login_ecran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ListeProduits extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
               actions: [
          // Bouton de déconnexion
       IconButton(
  icon: Icon(Icons.exit_to_app),
  onPressed: () async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()), 
    );
  },
),

        ],
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('produits').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
             return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data!.docs[index];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ds['designation'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 16.0), // Ajustez la marge selon vos besoins
                          child: Text(
                            '${ds['prix']} DH',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(ds['categorie']),
                    leading: Image.network(
                   ds['photo'], // Utilisez le champ d'URL de l'image ici
                  width: 60.0,
                   height: 60.0,
                   fit: BoxFit.cover,
               ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        // Supprimer l'élément de la base de données ici
                        db.collection('produits').doc(ds.id).delete();
                      },
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur de connexion',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjoutProduitPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}