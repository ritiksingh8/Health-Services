import 'package:flutter/material.dart';
import '../widgets/reviews.dart';
import '../models/doctor.dart';

class DoctorsReviewsScreen extends StatelessWidget {
  static const routeName = '/all-reviews';
  @override
  Widget build(BuildContext context) {
    final doctor = ModalRoute.of(context).settings.arguments as Doctor;
    final bool showAll = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews of'),
      ),
      body: Reviews(doctor, showAll),
    );
  }
}
