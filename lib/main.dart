import 'package:flutter/material.dart';
import 'package:lfc_web/provider/accounts_provider.dart';
import 'package:lfc_web/provider/announcements_provider.dart';
import 'package:lfc_web/provider/book_provider.dart';
import 'package:lfc_web/provider/latest_provider.dart';
import 'package:lfc_web/provider/pamphlets_provider.dart';
import 'package:lfc_web/provider/testimonies_provider.dart';
import 'package:lfc_web/provider/wsf_provider.dart';
import 'package:lfc_web/screens/large_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'provider/audio_provider.dart';
import 'provider/video_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAJXiu1QTTc1KMRpQCcMfb-kbRkornZnfk",
        authDomain: "lfctrademore-5eefe.firebaseapp.com",
        projectId: "lfctrademore-5eefe",
        storageBucket: "lfctrademore-5eefe.appspot.com",
        messagingSenderId: "460386263",
        appId: "1:460386263:web:06c0b4aac9fb1e5c45e592",
        measurementId: "G-76TDNQJNKX"),
  );
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WSFProvider()),
        ChangeNotifierProvider(create: (context) => AnnouncementsProvider()),
        ChangeNotifierProvider(create: (context) => LatestProvider()),
        ChangeNotifierProvider(create: (context) => VideoProvider()),
        ChangeNotifierProvider(create: (context) => AudioProvider()),
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => AccountsProvider()),
        ChangeNotifierProvider(create: (context) => TestimoniesProvider()),
        ChangeNotifierProvider(create: (context) =>  PamphletsProvider()),
       
      ],
      child: MaterialApp(
        title: 'LFC TRADEMORE APP ADMIN',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const LargeScreen(),
      ),
    );
  }
}
