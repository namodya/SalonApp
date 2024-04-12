import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatefulWidget {
  static const String id = "feedback-screen";

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedback').snapshots(),
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

          return Center(
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(Colors.teal.shade100),
                columns: [
                  DataColumn(
                    label: Text(
                      'Full Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Feedback',
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
                      'Action',
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
                  final dateTime = data['timestamp']
                      ?.toDate(); // Assuming 'timestamp' is a Timestamp field
                  final formattedDate =
                      dateTime != null ? DateFormat.yMd().format(dateTime) : '';
                  final formattedTime =
                      dateTime != null ? DateFormat.jm().format(dateTime) : '';
                  return DataRow(
                    cells: [
                      DataCell(Text(data['fullName']?.toString() ?? '')),
                      DataCell(Text(data['email']?.toString() ?? '')),
                      DataCell(Text(data['feedback']?.toString() ?? '')),
                      DataCell(Text(formattedDate)),
                      DataCell(Text(formattedTime)),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Delete the feedback data from Firestore
                            document.reference.delete();
                          },
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
            ),
          );
        },
      ),
    );
  }
}
