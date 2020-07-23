import 'package:flutter/material.dart';
import '../widgets/hospital_item.dart';
import '../models/hospital.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalScreen extends StatefulWidget {
  @override
  _HospitalScreenState createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Of Hospitals'),
      ),
      body: FutureBuilder(
        future: Firestore.instance.collection('hospitals').getDocuments(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final hospitalDocs = futureSnapshot.data.documents;

          return ListView.builder(
            itemBuilder: (ctx, index) => HospitalItem(
              Hospital(
                name: hospitalDocs[index]['name'],
                description: hospitalDocs[index]['description'],
                lat: hospitalDocs[index]['lat'],
                lng: hospitalDocs[index]['lng'],
                imageurl: hospitalDocs[index]['imageurl'],
                website: hospitalDocs[index]['website'],
                phoneNo: hospitalDocs[index]['phone_no'],
                email: hospitalDocs[index]['email'],
              ),
            ),
            itemCount: hospitalDocs.length,
          );
        },
      ),
    );
  }
}
