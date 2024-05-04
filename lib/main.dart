import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_ib/login/login.dart';
import 'package:admin_ib/style.dart';

// import 'package:flutter_native_splash/flutter_native_splash.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await Firebase.initializeApp();
  await Future.delayed(const Duration(seconds: 1));
  // FlutterNativeSplash.remove();
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.teal,
  //     statusBarBrightness: Brightness.light,
  //   ),
  // );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: CouleurPrincipale,
        useMaterial3: false,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: CouleurPrincipale),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginHome(),
    );
  }
}
