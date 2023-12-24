import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUpWithEmailAndPassword(BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // Ajoutez des étapes supplémentaires si nécessaire après la création du compte

      // Affichez un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Compte créé avec succès!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("Erreur de création de compte: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur de création de compte'),
          content: Text(e.message ?? 'Une erreur s\'est produite'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                icon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signUpWithEmailAndPassword(context),
              child: Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
