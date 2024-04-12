import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HairspecialistScreen extends StatefulWidget {
  static const String id = "hair_specialist_management_screen";

  @override
  _HairSpecialistManagementScreenState createState() =>
      _HairSpecialistManagementScreenState();
}

class _HairSpecialistManagementScreenState extends State<HairspecialistScreen> {
  String experience = '';
  String expertise = '';
  File? imageFile;
  String name = '';
  double rating = 0;

  List<Map<String, dynamic>> hairSpecialists = [];

  final ImagePicker _picker = ImagePicker();

  final TextEditingController experienceController = TextEditingController();
  final TextEditingController expertiseController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    experienceController.dispose();
    expertiseController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void addHairSpecialist() {
    setState(() {
      hairSpecialists.add({
        'experience': experience,
        'expertise': expertise,
        'image': imageFile,
        'name': name,
        'rating': rating,
      });
      clearForm();
    });
  }

  void clearForm() {
    setState(() {
      experience = '';
      expertise = '';
      imageFile = null;
      name = '';
      rating = 0;
    });
    experienceController.clear();
    expertiseController.clear();
    nameController.clear();
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
        title: Text("Hair Specialist Management"),
        backgroundColor: Colors.teal,
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
                    "Add New Hair Specialist",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: experienceController,
                    decoration: InputDecoration(
                      labelText: "Experience",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      experience = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    controller: expertiseController,
                    decoration: InputDecoration(
                      labelText: "Expertise",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      expertise = value;
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
                  Stack(
                    children: [
                      ElevatedButton(
                        onPressed: getImageFromGallery,
                        child: Text('Select Image'),
                      ),
                      if (imageFile != null)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text(
                        "Rating: ",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      RatingBar.builder(
                        initialRating: rating,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 30.0,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: addHairSpecialist,
                        child: Text('Add Specialist'),
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
                    "Hair Specialists",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: hairSpecialists.length,
                      itemBuilder: (context, index) {
                        final specialist = hairSpecialists[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: specialist['image'] != null
                                  ? FileImage(File(specialist['image'].path))
                                  : AssetImage('../assets/face4.jpg')
                                      as ImageProvider,
                            ),
                            title: Text(
                              specialist['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Experience: ${specialist['experience']}'),
                                Text('Expertise: ${specialist['expertise']}'),
                                RatingBarIndicator(
                                  rating: specialist['rating'],
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
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
