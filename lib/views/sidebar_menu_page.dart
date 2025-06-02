import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final Function(String)?
  onMenuTap; // opsional callback jika mau handle navigasi dari sini

  SidebarMenu({this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
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
                    //close drawer
                    Navigator.pop(context);
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
                  leading: Icon(Icons.favorite),
                  title: Text('Favorite'),
                  onTap: () {
                    Navigator.pop(context);
                    if (onMenuTap != null) onMenuTap!("favorite");
                    Navigator.pushNamed(context, '/faforite');
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
            onTap: () {
              Navigator.pop(context); // tutup drawer dulu
              if (onMenuTap != null) onMenuTap!("logout");
              Navigator.pushReplacementNamed(context, '/logout');
            },
          ),
        ],
      ),
    );
  }
}
