import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserAppointmentScreen extends StatefulWidget {
  static const routeName = '/user-appointment-screen';

  @override
  _UserAppointmentScreenState createState() => _UserAppointmentScreenState();
}

class _UserAppointmentScreenState extends State<UserAppointmentScreen> {
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

  String doctorId;

  void segregateAppointments(List<DocumentSnapshot> appointmentDocs) {
    todayList = {
      '10': 0,
      '1': 0,
      '3': 0,
      '5': 0,
    };
    tomorrowList = {
      '10': 0,
      '1': 0,
      '3': 0,
      '5': 0,
    };
    dayAfterTomorrowList = {
      '10': 0,
      '1': 0,
      '3': 0,
      '5': 0,
    };

    appointmentDocs.forEach((doc) {
      if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
              doc['time'].seconds * 1000)) ==
          DateFormat.yMMMd().format(today)) {
        todayList[doc['slot']] += 1;
      } else if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
              doc['time'].seconds * 1000)) ==
          DateFormat.yMMMd().format(tomorrow)) {
        tomorrowList[doc['slot']] += 1;
      } else if (DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(
              doc['time'].seconds * 1000)) ==
          DateFormat.yMMMd().format(tomorrow)) {
        dayAfterTomorrowList[doc['slot']] += 1;
      } else {}
    });
  }

  // void _addNewAppointment(
  //   String reviewContent,
  //   String name,
  // ) async {
  //   await Firestore.instance
  //       .collection('doctors')
  //       .document(doctorId)
  //       .collection('appointments')
  //       .add({
  //     'createdAt': Timestamp.now(),
  //     'creatorImageUrl': imageUrl,
  //     'creatorName': name,
  //     'review': reviewContent,
  //   });
  // }

  // void _startAddNewAppointment(BuildContext ctx,String slot) {
  //   showModalBottomSheet(
  //     context: ctx,
  //     builder: (_) {
  //       return GestureDetector(
  //         onTap: () {},
  //         child: NewAppointment(_addNewAppointment),
  //         behavior: HitTestBehavior.opaque,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    doctorId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Make an Appointment!'),
      ),
      body: FutureBuilder(
          future: Firestore.instance
              .collection('doctors')
              .document(doctorId)
              .collection('appointments')
              .getDocuments(),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final appointmentDocs = futureSnapshot.data.documents;

            segregateAppointments(appointmentDocs);

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.lime[100],
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(today),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '10 AM - 12 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['10'] < 3) && (today.hour < 10)
                                        ? () {}
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '1 PM - 3 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['1'] < 3) && (today.hour < 13)
                                        ? () {}
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '3 PM - 5 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['3'] < 3) && (today.hour < 15)
                                        ? () {}
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '5 PM - 7 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (todayList['5'] < 3) && (today.hour < 17)
                                        ? () {}
                                        : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.lime[100],
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(tomorrow),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                  child: Text(
                                    '10 AM - 12 PM',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed:
                                      (tomorrowList['10'] < 3) ? () {} : null,
                                  color: Colors.blue),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '1 PM - 3 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (tomorrowList['1'] < 3) ? () {} : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '3 PM - 5 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (tomorrowList['3'] < 3) ? () {} : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '5 PM - 7 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed:
                                    (tomorrowList['5'] < 3) ? () {} : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.lime[100],
                    margin: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          DateFormat.yMMMd().format(dayAfterTomorrow),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                  child: Text(
                                    '10 AM - 12 PM',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: (dayAfterTomorrowList['10'] < 3)
                                      ? () {}
                                      : null,
                                  color: Colors.blue),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '1 PM - 3 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (dayAfterTomorrowList['1'] < 3)
                                    ? () {}
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '3 PM - 5 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (dayAfterTomorrowList['3'] < 3)
                                    ? () {}
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                            Container(
                              width: 130,
                              child: RaisedButton(
                                child: Text(
                                  '5 PM - 7 PM',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (dayAfterTomorrowList['5'] < 3)
                                    ? () {}
                                    : null,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
