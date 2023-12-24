import 'package:flutter/material.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/produit.dart';
class ProduitItem extends StatelessWidget {
  ProduitItem({Key? key, required this.produit }): super(key:key);

  final Produit produit;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(produit.designation),
      subtitle: Text(produit.marque),
      trailing: Text('${produit.prix} €'),
    );
  }
}
