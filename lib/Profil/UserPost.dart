import 'dart:convert';
import 'package:admin_ib/Util/style.dart';
import 'package:admin_ib/login/authServices.dart';
import 'package:admin_ib/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:admin_ib/Profil/insert_data.dart';
 
import '../detailpage.dart';

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
          .where((Actualite) => Actualite['auteur'] == user.displayName)
          .toList();

      post.sort((a, b) => b["id"].compareTo(a["id"]));
    } else {
      // Handle if user is not logged in
      // For example, navigate to login screen
    }

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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(
            //     builder: (context) => HomePage(),
            //   ),
            //   (Route<dynamic> route) => false,
            // );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Text("${mail}"),
          IconButton(
            onPressed: () {
              AuthService().signOut().then((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginHome()),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: CouleurPrincipale,
                  radius: 33,
                  backgroundImage: NetworkImage(userPhotoUrl ?? ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin: ${userName ?? ''}',
                      style: TitreStyle,
                    ),
                    Text(
                      'Mail: ${mail ?? ''}',
                      style: DescStyle,
                    ),
                  ],
                ),
              ),
              Divider(),
              Center(
                child: Text(
                  'Mes Posts',
                  style: TitreStyle,
                ),
              ),
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
                            (index) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return DetailPage(
                                      categorie: "",
                                  
                                      titre: post[index]['titre'],
                                      desc: post[index]['detail'],
                                      image1: post[index]['source'],
                              
                                      auteur: post[index]['auteur'],
                                    );
                                  }),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black12,
                                      style: BorderStyle.solid,
                                    ),
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          post[index]["titre"],
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: TitreStyle,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        child: Image.network(
                     

                                          // ignore: prefer_interpolation_to_compose_strings
                                    
                                              post[index]["source"],
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Confirmation"),
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
                                            child: Text("Supprimer",
                                                style: DescStyle),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text("Modifier",
                                                style: DescStyle),
                                          ),
                                          TextButton.icon(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.share_outlined,
                                              color: CouleurPrincipale,
                                            ),
                                            label: Text("Partager",
                                                style: DescStyle),
                                          )
                                        ],
                                      ),
                                    ],
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
