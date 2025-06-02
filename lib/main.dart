import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royal_clothes/views/home_page.dart';
import 'package:royal_clothes/views/category_page.dart';
import 'package:royal_clothes/views/landing_page.dart';
import 'package:royal_clothes/views/login_page.dart'; 
import 'package:royal_clothes/views/signup_page.dart';
import 'package:royal_clothes/views/favorite_page.dart';
import 'package:royal_clothes/views/kesan_saran_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // WAJIB sebelum SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Clothes',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Garamond',
      ),
      initialRoute: isLoggedIn ? '/home' : '/', // Cek status login
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(), 
        '/signup': (context) => SignupPage(),
        '/category': (context) => CategoryPage(initialCategory: "women's clothing"),
        '/favorite': (context) => FavoritePage(),
        '/kesan_saran': (context) => KesanSaranPage(),
        
        // Tambah route lain sesuai kebutuhan
      },
    );
  }
}
