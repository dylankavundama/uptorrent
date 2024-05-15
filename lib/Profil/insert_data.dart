import 'dart:convert';
import 'dart:io';
import 'package:admin_ib/style.dart';
import 'package:admin_ib/modal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
// import 'package:line_icons/line_icons.dart';
import 'package:admin_ib/Profil/UserPost.dart';
import 'dart:core';
import 'package:file_picker/file_picker.dart';

// ignore: camel_case_types
class Inset_Data extends StatefulWidget {
  const Inset_Data({super.key});
  @override
  State<Inset_Data> createState() => _Inset_DataState();
}

// ignore: camel_case_types
class _Inset_DataState extends State<Inset_Data> {
  TextEditingController nom = TextEditingController();
  TextEditingController video = TextEditingController();
  TextEditingController detail = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController dateN = TextEditingController();

  @override
  void initState() {
    super.initState();
    getrecord();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  late String idenseu;
  // ignore: prefer_typing_uninitialized_variables
  var selectens;
  showToast({required String msg}) {
    // ignore: avoid_print
    return print('');
  }

  List dataens = [];
  Future<void> getrecord() async {
    var url = "$Adress_IP/categorie.php";
    try {
      var response = await http.get(Uri.parse(url));
      setState(() {
        dataens = jsonDecode(response.body);
      });
    } catch (e) {}
  }

  Future<void> savadatas(Entreprise entreprise, String email) async {
    if (nom.text.isEmpty ||
        detail.text.isEmpty ||
        video.text.isEmpty ||
        source.text.isEmpty ||
        dateN.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vous avez un champ vide'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    try {
      var url = "$Adress_IP/profil/ajouter.php";
      Uri ulr = Uri.parse(url);
      var request = http.MultipartRequest('POST', ulr);

      request.fields['titre'] = nom.text;
      request.fields['video'] = video.text;
      request.fields['cat'] = idenseu;
      request.fields['source'] = source.text;
      request.fields['detail'] = detail.text;
      request.fields['dateN'] = dateN.text;
      request.fields['auteur'] = email; // Insert email here
      request.files.add(http.MultipartFile.fromBytes(
          'fichier', File(_image!.path).readAsBytesSync(),
          filename: _image!.path));

      var res = await request.send();
      var response = await http.Response.fromStream(res);

      if (response.statusCode == 200) {
        showToast(msg: "Succès !");
      } else {
        showToast(msg: "Problème d'insertion !");
      }
    } catch (e) {
      showToast(msg: 'Erreur survenue');
    }
  }

  bool _isLoading = false;
  File? _image;
  Future<void> _pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        setState(() {
          _image = File(result.files.single.path!);
        });
      }
    } catch (e) {
      debugPrint('Erreur lors de la sélection de l\'image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CouleurPrincipale,
        title: Text(
          ' ${user?.displayName ?? "Non défini"}',
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Center(
                    child: Text(
                      "Ajouter un post",
                      style: TitreStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Stack(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.list),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                        readOnly: true,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: DropdownButton(
                          hint: const Text(
                              "-------------Sélectionner une catégorie-----------"),
                          items: dataens.map((list) {
                            return DropdownMenuItem(
                              value: list["id"],
                              child: Text(list["nom"]),
                            );
                          }).toList(),
                          value: selectens,
                          onChanged: (value) {
                            selectens = value;
                            idenseu = selectens;
                            // ignore: prefer_interpolation_to_compose_strings
                            debugPrint("Valeur: " + selectens);
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: nom,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Titre",
                      labelText: "Titre du post"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: detail,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Detail",
                      labelText: "Description"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: video,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Video",
                      labelText: "video url"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: source,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.web),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      hintText: "Url image",
                      labelText: "Image"),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  controller: dateN,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: const InputDecoration(
                    hintText: 'Selectionner la  Date',
                    suffixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextField(
                  readOnly: true,
                  onTap: () => _pickImage(),
                  decoration: const InputDecoration(
                    hintText: 'Fichier',
                    suffixIcon: Icon(Icons.file_download),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  minWidth: double.maxFinite,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: CouleurPrincipale,
                  onPressed: () {
                    if (idenseu.isEmpty) {
                      showToast(msg: "y'a une case vide");
                    } else if (source.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else if (dateN.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else if (detail.text.isEmpty &&
                        idenseu.isEmpty &&
                        source.text.isEmpty) {
                      showToast(msg: "Y'a une case vide");
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      savadatas(
                        Entreprise(
                          titre: idenseu.trim(),
                          detail: detail.text.trim(),
                          video: video.text.trim(),
                          source: source.text.trim(),
                          dateN: source.text.trim(),
                        ),
                        FirebaseAuth.instance.currentUser?.displayName ?? '',
                      ).then((value) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const UserPost(),
                          ),
                        );
                      }).whenComplete(() {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Ajouter",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        dateN.text = picked.toString().substring(0, 10);
      });
    }
  }
}
