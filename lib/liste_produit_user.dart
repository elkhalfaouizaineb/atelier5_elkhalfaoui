
import 'package:atelier4_z_elkhalfaoui_iir5g2/AjoutProduitPage.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/FavorisPage.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/ProfilePage.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/login_ecran.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/produit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ListeProduitsUser extends StatefulWidget {
  @override
  _ListeProduitsUserState createState() => _ListeProduitsUserState();
}

class _ListeProduitsUserState extends State<ListeProduitsUser> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> favoris = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des produits'),
        actions: [
          // Bouton de déconnexion
       
              IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavorisPage()),
        );
      },
    ),
         IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Récupérez l'utilisateur actuellement connecté
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
              
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                );
              }
            },
          ),
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
                bool isFavori = favoris.contains(ds.id);

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(16.0),
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
                          margin: EdgeInsets.only(left: 16.0),
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
                      icon: Icon(
                        isFavori ? Icons.favorite : Icons.favorite_border,
                        color: isFavori ? Colors.red : null,
                      ),
                      onPressed: () {
                        if (isFavori) {
                          _retirerDesFavoris(ds.id);
                        } else {
                          _ajouterAuxFavoris(ds);
                        }
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
     
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _ajouterAuxFavoris(DocumentSnapshot produit) {
    if (!favoris.contains(produit.id)) {
      FirebaseFirestore.instance.collection('favories').add({
        'designation': produit['designation'],
        'prix': produit['prix'],
        'quantite': produit['quantite'],
        'categorie': produit['categorie'],
        'marque': produit['marque'],
      }).then((value) {
        setState(() {
          favoris.add(produit.id);
        });
      });
    }
  }

  void _retirerDesFavoris(String produitId) {
    FirebaseFirestore.instance
        .collection('favories')
        .where('id', isEqualTo: produitId)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        snapshot.docs.first.reference.delete().then((value) {
          setState(() {
            favoris.remove(produitId);
          });
        });
      }
    });
  }
}

