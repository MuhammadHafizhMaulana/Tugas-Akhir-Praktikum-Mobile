import 'package:flutter/material.dart';
import 'package:royal_clothes/views/appBar_page.dart';
import 'package:royal_clothes/views/sidebar_menu_page.dart';

class KesanDanSaranPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppbarPage(
        title: 'Royal Clothes',
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      drawer: SidebarMenu(),
      body: SingleChildScrollView(
        // Membuat halaman scrollable
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card 1: Foto dan Data Diri
            Card(
              color: Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/habib.png',
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Data Diri
                    Text(
                      "Nama: Ahmad Hanif Habib Annafi\n"
                      "Email: habibannafi76@gmail.com\n"
                      "NIM  : 123210147\n"
                      "Kelas: Mobile IF-D",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Garamond',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card 2: Kesan
            Card(
              color: Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kesan :",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Garamond',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Kelas Mobile Android ini sangat menarik dan memberikan banyak wawasan baru tentang pengembangan aplikasi mobile. Saya belajar banyak tentang Flutter, Dart, dan bagaimana membangun aplikasi yang responsif dan menarik. Pengalaman ini sangat berharga bagi saya sebagai mahasiswa teknik informatika.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Garamond',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card 3: Saran
            Card(
              color: Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Saran :",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Garamond',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Saran saya adalah untuk teknik pembelajaran mandiri lebih di arahkan lagi mana saja aspek pendukung yang harus dipelajari. Saya juga berharap ada lebih banyak proyek praktis yang bisa dikerjakan di luar kelas untuk memperdalam pemahaman tentang konsep-konsep yang diajarkan.",
                        style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontFamily: 'Garamond',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
