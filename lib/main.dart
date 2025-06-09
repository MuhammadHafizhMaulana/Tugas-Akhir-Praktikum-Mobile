import 'package:flutter/material.dart';
import 'package:royal_clothes/db/database_helper.dart';
import 'package:royal_clothes/views/location_page.dart';
import 'package:royal_clothes/views/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royal_clothes/views/home_page.dart';
import 'package:royal_clothes/views/category_page.dart';
import 'package:royal_clothes/views/landing_page.dart';
import 'package:royal_clothes/views/login_page.dart';
import 'package:royal_clothes/views/signup_page.dart';
import 'package:royal_clothes/views/favorite_page.dart';
import 'package:royal_clothes/views/kesan_saran_page.dart';
import 'package:royal_clothes/views/payment_page.dart';
import 'package:royal_clothes/views/payment_history_page.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  await initializeDateFormatting('id_ID', null);
  await DBHelper().deleteDatabaseIfExists();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Royal Clothes',
      theme: ThemeData(primarySwatch: Colors.amber, fontFamily: 'Garamond'),
      initialRoute: isLoggedIn ? '/home' : '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => LandingPage());
          case '/home':
            return MaterialPageRoute(builder: (_) => HomePage());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginPage());
          case '/signup':
            return MaterialPageRoute(builder: (_) => SignupPage());
          case '/category':
            return MaterialPageRoute(
              builder: (_) => CategoryPage(initialCategory: "women's clothing"),
            );
          case '/favorite':
            return MaterialPageRoute(
              builder: (_) => FavoritePage(endpoint: 'products'),
            );
          case '/kesan_saran':
            return MaterialPageRoute(builder: (_) => KesanDanSaranPage());
          case '/profile':
            final email =
                settings.arguments as String; // Mengambil email dari arguments
            return MaterialPageRoute(builder: (_) => ProfilePage(email: email));
          case '/payment':
            final arguments = settings.arguments;

            if (arguments is Map<String, dynamic>) {
              final int userId = arguments['userId'];
              final int productId = arguments['productId'];
              final String endpoint = arguments['endpoint'];

              return MaterialPageRoute(
                builder:
                    (_) => PaymentPage(
                      userId: userId,
                      productId: productId,
                      endpoint: endpoint,
                    ),
              );
            } else {
              return MaterialPageRoute(
                builder:
                    (_) => Scaffold(
                      body: Center(
                        child: Text('Arguments not found or incorrect'),
                      ),
                    ),
              );
            }

          case '/paymenthistory':
            return MaterialPageRoute(
              builder: (_) => PaymentHistoryPage(endpoint: 'products'),
            );
          case '/location':
            return MaterialPageRoute(builder: (_) => LocationPage());
          default:
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(child: Text('Halaman tidak ditemukan')),
                  ),
            );
        }
      },
    );
  }
}
