import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MassageScreen extends StatefulWidget {
  static const String id = "massage-screen";

  @override
  _MassageScreenState createState() => _MassageScreenState();
}

class _MassageScreenState extends State<MassageScreen> {
  final TextEditingController _receiverEmailController =
      TextEditingController();
  final TextEditingController _senderEmailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool _hasNewMessages = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Massage Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.teal.shade100,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Email',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _receiverEmailController,
                      decoration: InputDecoration(
                        hintText: 'Receiver Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _senderEmailController,
                      decoration: InputDecoration(
                        hintText: 'Sender Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        hintText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _bodyController,
                        maxLines: null,
                        expands: true,
                        decoration: InputDecoration(
                          hintText: 'Body',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _hasNewMessages = true;
                        });
                      },
                      child: Text('Send Email'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.notifications,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            // Handle notification icon press
                          },
                        ),
                        if (_hasNewMessages)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 16.0),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('messages')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.teal),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                                'Massage',
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
                          rows: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            final dateTime = data['timestamp']
                                ?.toDate(); // Assuming 'timestamp' is a Timestamp field
                            final formattedDate = dateTime != null
                                ? DateFormat.yMd().format(dateTime)
                                : '';
                            final formattedTime = dateTime != null
                                ? DateFormat.jm().format(dateTime)
                                : '';

                            return DataRow(
                              cells: [
                                DataCell(Text(data['name']?.toString() ?? '')),
                                DataCell(Text(data['email']?.toString() ?? '')),
                                DataCell(
                                    Text(data['message']?.toString() ?? '')),
                                DataCell(Text(formattedDate)),
                                DataCell(Text(formattedTime)),
                                DataCell(
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      // Delete the massage data from Firestore
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
