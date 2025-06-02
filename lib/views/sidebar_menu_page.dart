import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final Function(String)? onMenuTap; // opsional callback jika mau handle navigasi dari sini

  SidebarMenu({this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFF121212),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Menu Sidebar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              if (onMenuTap != null) onMenuTap!("home");
              // atau langsung navigasi di sini jika mau
              // Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Kategori'),
            onTap: () {
              Navigator.pop(context);
              if (onMenuTap != null) onMenuTap!("kategori");
              // Navigator.pushNamed(context, '/kategori');
            },
          ),
          // Tambah menu lain sesuai kebutuhan
        ],
      ),
    );
  }
}
