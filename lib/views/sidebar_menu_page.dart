import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SidebarMenu extends StatelessWidget {
  final Function(String) ?
    onMenuTap; // opsional callback jika mau handle navigasi dari sini

  SidebarMenu({
    this.onMenuTap
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: < Widget > [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFF121212)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                    if (onMenuTap != null) onMenuTap!("home");
                    Navigator.pushReplacementNamed(context, '/home');
                    //close drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profil'),
                  onTap: () async {
                    Navigator.pop(context);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String ? email = prefs.getString('userEmail'); // ambil email dari session

                    if (email != null) {
                      Navigator.pushNamed(context, '/profile', arguments: email);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email tidak ditemukan!")),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  title: Text('Kategori'),
                  onTap: () {
                    Navigator.pop(context);
                    if (onMenuTap != null) onMenuTap!("kategori");
                    Navigator.pushNamed(context, '/category');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Riwayat Belanja'),
                  onTap: () {
                    Navigator.pop(context);
                    if (onMenuTap != null) onMenuTap!("paymenthistory");
                    Navigator.pushNamed(context, '/paymenthistory');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text('Kesan & Saran'),
                  onTap: () {
                    Navigator.pop(context);
                    if (onMenuTap != null) onMenuTap!("kesan_saran");
                    Navigator.pushNamed(context, '/kesan_saran');
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Logout', style: TextStyle(color: Colors.redAccent)),
            onTap: () async {
              Navigator.pop(context); // tutup drawer dulu

              //hapus status login
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // atau prefs.remove('isLoggedIn');

              //navigasi ke login
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }
}