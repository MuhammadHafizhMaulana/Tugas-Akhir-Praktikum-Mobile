import 'package:flutter/material.dart';
import 'package:royal_clothes/views/home_page.dart';
import 'package:royal_clothes/views/category_page.dart';
import 'package:royal_clothes/views/landing_page.dart';
import 'package:royal_clothes/views/login_page.dart'; 
import 'package:royal_clothes/views/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Clothes',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        fontFamily: 'Garamond',
      ),
      initialRoute: '/', // route awal
      routes: {
        '/': (context) => LandingPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(), 
        '/signup': (context) => SignupPage(),
        
        // Tambah route lain sesuai kebutuhan
      },
    );
  }
}
