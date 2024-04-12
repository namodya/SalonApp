import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScreen extends StatefulWidget {
  static const String id = "user-screen";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    setState(() {
      _users = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _createOrUpdateUser() async {
    final newUser = {
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'Password': _passwordController.text,
    };
    await _firestore.collection('users').add(newUser);
    _clearForm();
    _fetchUserData();
  }

  Future<void> _deleteUser(int index) async {
    final userId = _users[index]['id'];
    await _firestore.collection('users').doc(userId).delete();
    setState(() {
      _users.removeAt(index);
    });
  }

  void _clearForm() {
    _fullNameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        backgroundColor: Color.fromARGB(255, 87, 162, 155),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  columnSpacing: 16.0,
                  dataRowColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected)
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.white,
                  ),
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Colors.teal,
                  ),
                  headingTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: [
                    DataColumn(label: Text('Full Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Password')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: _users
                      .asMap()
                      .map((index, user) => MapEntry(
                            index,
                            DataRow(
                              cells: [
                                DataCell(Text(user['fullName'] ?? '')),
                                DataCell(Text(user['email'] ?? '')),
                                DataCell(Text(user['Password'] ?? '')),
                                DataCell(
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.blue,
                                        onPressed: () {
                                          _fillForm(user);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          _deleteUser(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .values
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createOrUpdateUser,
              child: Text(
                'Update User',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fillForm(Map<String, dynamic> user) {
    _fullNameController.text = user['fullName'] ?? '';
    _emailController.text = user['email'] ?? '';
    _passwordController.text = user['Password'] ?? '';
  }
}
