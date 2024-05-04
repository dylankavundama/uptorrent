import 'package:share/share.dart';
import 'package:admin_ib/Util/style.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Widget_UI extends StatelessWidget {
  const Widget_UI({
    required this.image,
    required this.titre,
    required this.desc,
    required this.date,
    this.maxLength = 60,
    super.key,
  });

  final String image;
  final String titre;
  final String desc;
  final String date;
  final int maxLength;
  @override
  Widget build(BuildContext context) {
    final ww = MediaQuery.of(context).size.width;
    String displayedText = titre.length <= maxLength
        ? titre
        : '${titre.substring(0, maxLength)}...';
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: SizedBox(
            // Prend toute la taille de l'écran
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.23,
            // Enfant : Image
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    'Erreur de chargement de l\'image',
                    style: TextStyle(color: Colors.red),
                  ),
                );
              },
            ),
          ),
        ),
        Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  displayedText,
                  style: DescStyle,
                  maxLines: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    date,
                    style: SousTStyle,
                  ),

                  Text(
                    'Categorie',
                    style: SousTStyle,
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(Icons.share),
                  // )
                  TextButton(
               onPressed: () {
              const url =
                  'https://play.google.com/store/apps/details?id=com.ibapp';
              Share.share(
                  "Actu :$titre},\n Description :${desc}\n Telecharger l'Application IB App\n$url");
            },
                    child: Text(
                      'Partager',
                      style: SousTStyle,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
