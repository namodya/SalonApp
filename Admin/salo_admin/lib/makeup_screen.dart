import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MakeupScreen extends StatefulWidget {
  static const String id = "makeup-management-screen";

  @override
  _MakeupManagementScreenState createState() => _MakeupManagementScreenState();
}

class _MakeupManagementScreenState extends State<MakeupScreen> {
  String description = '';
  File? imageFile;
  String name = '';
  double price = 0;

  List<Map<String, dynamic>> makeupItems = [];

  final ImagePicker _picker = ImagePicker();

  // Controllers for TextFields
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    descriptionController.dispose();
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void addMakeupItem() {
    setState(() {
      makeupItems.add({
        'description': description,
        'image': imageFile,
        'name': name,
        'price': price,
      });
      clearForm();
    });
  }

  void clearForm() {
    setState(() {
      description = '';
      imageFile = null;
      name = '';
      price = 0;
    });
    // Clear TextFields by updating their controllers
    descriptionController.clear();
    nameController.clear();
    priceController.clear();
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Makeup Items"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Row(
        children: [
          // Left panel with form
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Makeup Item",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      labelText: "Price (\$)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      price = double.tryParse(value) ?? 0;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: getImageFromGallery,
                        icon: Icon(Icons.image),
                        label: Text('Select Image'),
                        style: ElevatedButton.styleFrom(
                            // primary: Colors.deepPurple,
                            ),
                      ),
                      ElevatedButton(
                        onPressed: addMakeupItem,
                        child: Text('Add Item'),
                        style: ElevatedButton.styleFrom(
                            // primary: Colors.deepPurple,
                            ),
                      ),
                      ElevatedButton(
                        onPressed: clearForm,
                        child: Text('Clear Form'),
                        style: ElevatedButton.styleFrom(
                            // primary: Colors.deepPurple,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Right panel with table
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Makeup Items",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: makeupItems.length,
                      itemBuilder: (context, index) {
                        final item = makeupItems[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: item['image'] != null
                                  ? FileImage(File(item['image'].path))
                                  : AssetImage('../assets/effect.jpg')
                                      as ImageProvider,
                            ),
                            title: Text(
                              item['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${item['description']}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'Price: \$${item['price']}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
