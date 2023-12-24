import 'package:atelier4_z_elkhalfaoui_iir5g2/liste_produit.dart';
import 'package:atelier4_z_elkhalfaoui_iir5g2/liste_produit_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Center(
//         child: StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
           
//             if (!snapshot.hasData) {
//               return SignInScreen(); 
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               // User? user = snapshot.data;
//               return ListeProduits();
              
//             //  return Column(
//             //     mainAxisAlignment: MainAxisAlignment.center,
//             //     children: [
//             //       Text('Email: ${user?.email ?? "Unknown"}'),
//             //       ElevatedButton(
//             //         onPressed: () async {
//             //           await FirebaseAuth.instance.signOut();
//             //         },
//             //         child: Text('Logout'),
//             //       ),
//             //     ],
//             //   );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Login'),
    //   ),
      body: Center(
        child:  StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if (snapshot.hasData && snapshot.data != null) {
              User? user = snapshot.data!;
              checkUserRoleAndRedirect(user, context);
              return Scaffold(
                body: CircularProgressIndicator(),
              );
            } else {
              return Scaffold(
                
                body: SignInScreen(),
              );
            }
          }
        },
      ),
      ),
    );
  }
}
class SignInScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Une fois l'utilisateur connecté, vérifiez son rôle avant de rediriger
     // checkUserRoleAndRedirect(userCredential.user, context);

    } on FirebaseAuthException catch (e) {
      print("Erreur de connexion: $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur de connexion'),
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
        title: Text('Connexion'),
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
              onPressed: () => _signInWithEmailAndPassword(context),
              child: Text('Se connecter'),
            ),
            SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}


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

void checkUserRoleAndRedirect(User? user, BuildContext context) {
  if (user != null) {
    FirebaseFirestore.instance
        .collection('admin')
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot adminSnapshot) {
      if (adminSnapshot.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListeProduits()),
        );
      } else {
        FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get()
            .then((DocumentSnapshot userSnapshot) {
          if (userSnapshot.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ListeProduitsUser()),
            );
          } else {
            // If the user is neither admin nor normal user, display login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          }
        });
      }
    });
  } else {
    // Handle case where user is not logged in
    print('User not logged in!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}