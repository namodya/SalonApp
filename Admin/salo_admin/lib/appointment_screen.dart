import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentScreen extends StatefulWidget {
  static const String id = "appointment-screen";

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('appointments').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            );
          }

          return SingleChildScrollView(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.teal.shade100),
              columns: [
                DataColumn(
                  label: Text(
                    'Username',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'User Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Actions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
              rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                DateTime appointmentDate = (data['date'] as Timestamp).toDate();
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(appointmentDate);
                return DataRow(
                  cells: [
                    DataCell(Text(data['userName']?.toString() ?? '')),
                    DataCell(Text(data['userEmail']?.toString() ?? '')),
                    DataCell(Text(data['category']?.toString() ?? '')),
                    DataCell(Text(formattedDate)),
                    DataCell(Text(data['timeSlot']?.toString() ?? '')),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () {
                              // Implement edit functionality
                              _editAppointment(document.id, data);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              // Implement delete functionality
                              _deleteAppointment(document.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
              dividerThickness: 1.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _editAppointment(
      String documentId, Map<String, dynamic> data) async {
    // Implement your edit logic here
    // You can use the documentId and data to update the appointment in Firestore
    print('Edit appointment with ID: $documentId');
    print('Appointment data: $data');

    // Example update logic
    await _firestore.collection('appointments').doc(documentId).update({
      'category': 'Updated Category',
      // Update other fields as needed
    });
  }

  Future<void> _deleteAppointment(String documentId) async {
    // Implement your delete logic here
    // You can use the documentId to delete the appointment from Firestore
    print('Delete appointment with ID: $documentId');

    // Example delete logic
    await _firestore.collection('appointments').doc(documentId).delete();
  }
}
