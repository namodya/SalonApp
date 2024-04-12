import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HaircutScreen extends StatefulWidget {
  static const String id = "haircut-management-screen";

  @override
  _HaircutManagementScreenState createState() =>
      _HaircutManagementScreenState();
}

class _HaircutManagementScreenState extends State<HaircutScreen> {
  String description = '';
  File? imageFile;
  String name = '';
  double price = 0;

  List<Map<String, dynamic>> haircuts = [];

  final ImagePicker _picker = ImagePicker();

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void addHaircut() {
    setState(() {
      haircuts.add({
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
        title: Text("Haircut Management Screen"),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add New Haircut",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
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
                      labelText: "Price",
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
                      ),
                      ElevatedButton(
                        onPressed: addHaircut,
                        child: Text('Add Haircut'),
                      ),
                      ElevatedButton(
                        onPressed: clearForm,
                        child: Text('Clear Form'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Haircuts",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: haircuts.length,
                      itemBuilder: (context, index) {
                        final haircut = haircuts[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: haircut['image'] != null
                                  ? FileImage(File(haircut['image'].path))
                                  : AssetImage('../assets/kid.jpg')
                                      as ImageProvider,
                            ),
                            title: Text(
                              haircut['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description: ${haircut['description']}',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                Text(
                                  'Price: \$${haircut['price']}',
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
