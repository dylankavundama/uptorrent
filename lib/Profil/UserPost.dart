// ignore: file_names
import 'dart:convert';
import 'package:admin_ib/style.dart';
import 'package:admin_ib/login/authServices.dart';
import 'package:admin_ib/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:admin_ib/Profil/insert_data.dart';

class UserPost extends StatefulWidget {
  const UserPost({Key? key}) : super(key: key);
  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  List<dynamic> post = [];
  bool _isLoading = false;
  String? userName;
  String? userPhotoUrl;
  String? mail;

  fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var url = '$Adress_IP/actualite.php';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final List<dynamic> result = jsonDecode(response.body);

      post = result
          // ignore: non_constant_identifier_names
          .where((Actualite) => Actualite['auteur'] == user.displayName)
          .toList();

      post.sort((a, b) => b["id"].compareTo(a["id"]));
    } else {}

    setState(() {
      _isLoading = false;
    });
  }

  fetchUserData() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userName = user.displayName;
        userPhotoUrl = user.photoURL;
        mail = user.email;
      });
    }
  }

  Future<void> _refresh() async {
    fetchPosts();
    fetchUserData();
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchUserData();
  }

//delete
  Future<void> delrecord(String id) async {
    try {
      var url = "$Adress_IP/profil/delete.php";
      var result = await http.post(Uri.parse(url), body: {"id": id});
      var reponse = jsonDecode(result.body);
      if (reponse["Success"] == "True") {
        debugPrint("record deleted");
        fetchUserData();
      } else {
        debugPrint("Erreur de suppression");
        fetchUserData();
      }
    } catch (e) {
    //  print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Text("$mail"),
          IconButton(
            onPressed: () {
              AuthService().signOut().then((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginHome()),
                );
              });
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.redAccent,
            ),
          )
        ],
        iconTheme: IconThemeData(color: CouleurPrincipale),
        backgroundColor: Colors.white,
        title: Text(
          'Mon Espace',
          style: DescStyle,
        ),
      ),
      body: RefreshIndicator(
        color: CouleurPrincipale,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              // Center(
              //   child: Text(
              //     'Mes Posts',
              //     style: TitreStyle,
              //   ),
              // ),
              _isLoading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CouleurPrincipale,
                        ),
                      ),
                    )
                  : post.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.only(top: 111),
                          child: Column(
                            children: [
                              Center(
                                child: Image.asset(
                                  'assets/error.png',
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                              Text(
                                "Aucune donnée n'est enregistrée",
                                style: SousTStyle,
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: List.generate(
                            post.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirmation"),
                                            content: const Text(
                                                "Voulez-vous vraiment supprimer ce post ?"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Ferme le dialog
                                                  delrecord(post[index][
                                                      "id"]); // Supprime l'enregistrement
                                                },
                                                child: Text(
                                                  "Oui",
                                                  style: SousTStyle,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Ferme le dialog
                                                },
                                                child: Text(
                                                  "Non",
                                                  style: DescStyle,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.delete)),
                                title: Text(
                                  post[index]["titre"],
                                  style: DescStyle,
                                ),
                        
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    post[index]["source"],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Inset_Data(),
            ),
          );
        },
        child: const Icon(Icons.add_business_outlined),
      ),
    );
  }
}
