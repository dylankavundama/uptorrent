import 'dart:convert';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_icons/line_icon.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:admin_ib/Util/style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  DetailPage(
      {required this.desc,
      required this.auteur,
      required this.image1,
  
      required this.titre,
      categorie,
   
      super.key});
  String image1;

  String desc;
  String titre;

  String auteur;
  @override
  // ignore: library_private_types_in_public_api
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool fav = false;

  //banniere actu
  BannerAd? _bannerAd;

  bool _isLoaded = false;

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-7329797350611067/5003791578'
      : 'ca-app-pub-7329797350611067/5003791578';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _isLoaded = false;
    _loadAd();
  }

  void _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      return;
    }

    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    flutterTts.stop();
    super.dispose();
  }

  bool isFavorite = false;

  // Function to toggle favorite status
  void toggleFavorite() async {
    //  SharedPreferences prefs = await SharedPreferences.getInstance();
    //   List<String> favorites = prefs.getStringList('favorites') ?? [];
    String currentData = jsonEncode({
      'nom': widget.titre,
      'detail': widget.desc,
      'image1': widget.image1,
    
    });

    // setState(() {
    //   if (isFavorite) {
    //     favorites.remove(currentData);
    //   } else {
    //     favorites.add(currentData);
    //   }
    //   prefs.setStringList('favorites', favorites);
    //   isFavorite = !isFavorite;
    // });
  }

  // Function to check if current item is favorite
  void checkFavorite() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   List<String> favorites = prefs.getStringList('favorites') ?? [];
    String currentData = jsonEncode({
      'nom': widget.titre,
      'detail': widget.desc,
      'image1': widget.image1,
    
      // Add more data if needed
    });
    setState(() {
      //isFavorite = favorites.contains(currentData);
    });
  }

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

// Sythese

  final FlutterTts flutterTts = FlutterTts();
  TextEditingController textEditingController = TextEditingController();

  @override
  Future<void> speak(String text) async {
    await flutterTts.setLanguage('fr-FR');
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Column(
                  children: [
                    // Center(
                    //   child: IconButton(
                    //     icon: Icon(
                    //       isFavorite ? Icons.favorite : Icons.favorite_border,
                    //       color: isFavorite ? Colors.red : null,
                    //     ),
                    //     onPressed: toggleFavorite,
                    //   ),
                    // ),
                    Text(widget.titre, style: TitreStyle),
                  ],
                ),
              ),
              Stack(
                children: [
                  if (_bannerAd != null && _isLoaded)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: SizedBox(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ),
                    ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                    imageUrl:
                                        widget.image1),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: Image.network(
                              widget.image1,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                       
                      ],
                    ),
                  ],
                ),
              ),
              Text(widget.desc, style: TitreStyle),
              const Divider(
                thickness: 1,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  ListTile(
                    trailing: const Icon(Icons.architecture),
                    leading: const Icon(Icons.person),
                    title: Text(
                      "Auteur : ${widget.auteur}",
                      style: DescStyle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        child: IconButton(
                          onPressed: () {},
                          icon: const FaIcon(
                            FontAwesomeIcons.whatsapp,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Card(
                        child: IconButton(
                          onPressed: () {},
                          icon: const FaIcon(
                            FontAwesomeIcons.facebook,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      Card(
                        child: IconButton(
                          onPressed: () {},
                          icon: FaIcon(
                            FontAwesomeIcons.instagram,
                            size: 30,
                            color: Colors.red.shade400,
                          ),
                        ),
                      ),
                      Card(
                        child: IconButton(
                          onPressed: () {},
                          icon: const FaIcon(
                            FontAwesomeIcons.linkedin,
                            size: 30,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 73,
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0.0,
          child: FittedBox(
            fit: BoxFit.none,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  // String lat = widget.lat;
                  // String long = widget.long;
                  // String url =
                  //     'http://www.google.com/maps/search/?api=1&query=$lat,$long';
                  // launch(url);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 6.0),
                  height: 46,
                  width: 186,
                  decoration: BoxDecoration(
                    color: CouleurPrincipale,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: const Text(
                    "Le Direct",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData leadingIcon;
  final String titleText;
  final String trailingText;
  final VoidCallback onTap;

  const CustomListTile({
    super.key,
    required this.leadingIcon,
    required this.titleText,
    required this.trailingText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(leadingIcon),
      title: Text(
        titleText,
        style: DescStyle,
      ),
      trailing: Text(trailingText),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImagePage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.white,
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        ),
      ),
    );
  }
}
