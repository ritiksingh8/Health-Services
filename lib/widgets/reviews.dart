import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/doctor.dart';
import 'package:intl/intl.dart';

class Reviews extends StatelessWidget {
  final Doctor doctor;
  final bool showAll;
  Reviews(this.doctor, this.showAll);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 18,
        top: 18,
        right: 18,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Reviews:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          FutureBuilder(
            future: Firestore.instance
                .collection('doctors')
                .document(doctor.uid)
                .collection('reviews')
                .getDocuments(),
            builder: (ctx, reviewSnapshot) {
              if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final reviews = reviewSnapshot.data.documents;

              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: showAll
                    ? reviews.length
                    : (reviews.length < 1 ? reviews.length : 1),
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Card(
                      elevation: 2,
                      color: Colors.lime[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    reviews[index]['creatorImageUrl'],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      reviews[index]['creatorName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      DateFormat.yMMMd()
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  reviews[index]['createdAt']
                                                          .seconds *
                                                      1000))
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Divider(thickness: 2),
                            Text(
                              reviews[index]['review'],
                            ),
                            SizedBox(
                              height: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
