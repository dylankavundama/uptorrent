import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_ib/Profil/UserPost.dart';
import 'package:admin_ib/login/authServices.dart';
import 'package:admin_ib/style.dart';

class LoginHome extends StatefulWidget {
  const LoginHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginHomeState createState() => _LoginHomeState();
}

class _LoginHomeState extends State<LoginHome> {
  bool _inLoginProcess = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await AuthService().isLoggedIn(); // Exemple hypothétique

    if (isLoggedIn) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserPost(),
        ),
      );
    } else {
      // Sinon, l'utilisateur doit se connecter
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60),
              ),
     
              Center(
                child: Text(
                  'UP-torrent ',
                  style: TitreStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: Text(
                    "Assurez-vous d’avoir tous les droit",
                    style: DescStyle,
                  ),
                ),
              ),
              _inLoginProcess
                  ? Center(
                      child: CircularProgressIndicator(
                        color: CouleurPrincipale,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: GestureDetector(
                        onTap: () => signIn(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                CouleurPrincipale, // Couleur de fond ajoutée ici
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.053,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/g.png', // Remplacez par votre propre icône de Google
                                height: 24.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Google',
                                  style: GoogleFonts.abel(
                                      fontSize: 23,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn(BuildContext context) async {
    setState(() {
      _inLoginProcess = true;
    });

    await AuthService().signInWithGoogle();

    setState(() {
      _inLoginProcess = false;
    });

    // Vérifier à nouveau l'état de connexion après la connexion
    await checkLoginStatus();
  }
}
