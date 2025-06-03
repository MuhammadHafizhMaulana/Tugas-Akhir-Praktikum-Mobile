import 'package:flutter/material.dart';
import 'package:royal_clothes/db/database_helper.dart';

class ProfilePage extends StatefulWidget {
  final String email; // Email sebagai identitas login
  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  String _email = '';
  bool _isEditing = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await DBHelper().getUserByEmail(widget.email);
    if (user != null) {
      setState(() {
        _email = user['email'];
        _nameController.text = user['name'];
        _isLoading = false;
      });
    } else {
      // Handle user not found
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found")),
      );
    }
  }

  Future<void> _saveNewName() async {
    await DBHelper().updateUserName(_email, _nameController.text);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nama berhasil diperbarui")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: _email,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  _isEditing
                      ? ElevatedButton(
                          onPressed: _saveNewName,
                          child: Text("Simpan"),
                        )
                      : ElevatedButton(
                          onPressed: () => setState(() => _isEditing = true),
                          child: Text("Edit Nama"),
                        )
                ],
              ),
            ),
    );
  }
}
