import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorMainScreen extends StatefulWidget {
  static const routeName = '/doctor-main-screen';

  @override
  _DoctorMainScreenState createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  String doctorId;
  final DateTime today = DateTime.now();

  final DateTime tomorrow = DateTime.now().add(
    new Duration(days: 1),
  );

  final DateTime dayAfterTomorrow = DateTime.now().add(
    new Duration(days: 2),
  );

  var todayList;

  var tomorrowList;

  var dayAfterTomorrowList;

  var isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    FirebaseAuth.instance.currentUser().then((value) {
      doctorId = value.uid;
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
  }

  void segregateAppointments(List<DocumentSnapshot> appointmentDocs) {
    todayList = {
      '10': [],
      '1': [],
      '3': [],
      '5': [],
    };
    tomorrowList = {
      '10': [],
      '1': [],
      '3': [],
      '5': [],
    };
    dayAfterTomorrowList = {
      '10': [],
      '1': [],
      '3': [],
      '5': [],
    };

    appointmentDocs.forEach(
      (doc) {
        if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
                doc['time'].seconds * 1000)) ==
            DateFormat.yMMMd().format(today)) {
          todayList[doc['slot']].add(doc);
        } else if (DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(
                    doc['time'].seconds * 1000)) ==
            DateFormat.yMMMd().format(tomorrow)) {
          tomorrowList[doc['slot']].add(doc);
        } else if (DateFormat.yMMMd().format(
                DateTime.fromMillisecondsSinceEpoch(
                    doc['time'].seconds * 1000)) ==
            DateFormat.yMMMd().format(dayAfterTomorrow)) {
          dayAfterTomorrowList[doc['slot']].add(doc);
        } else {}
      },
    );
    print(todayList);
    print(tomorrowList);
    print(dayAfterTomorrowList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Main Screen'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('doctors')
                  .document(doctorId)
                  .collection('appointments')
                  .snapshots(),
              builder: (context, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final appointmentDocs = streamSnapshot.data.documents;

                segregateAppointments(appointmentDocs);

                return Text('');
              },
            ),
    );
  }
}
