import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../helpers/doctors_validation_list.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String name,
    File image,
    bool isLogin,
    BuildContext ctx,
    String regNo,
    bool isDoctorLogin,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (isDoctorLogin) {
        if (isDoctorLogin) {
          final foundDoctorMap = doctors_validation_list.where(
            (doctorMap) {
              return (doctorMap['email'] == email &&
                  doctorMap['regNo'] == regNo);
            },
          ).toList();
          if (foundDoctorMap.length == 0) {
            throw Error;
          }
          authResult = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(authResult.user.uid + '.jpg');

          await ref.putFile(image).onComplete;

          final url = await ref.getDownloadURL();

          await Firestore.instance
              .collection('doctors')
              .document(authResult.user.uid)
              .setData({
            'name': name,
            'email': email,
            'imageurl': url,
          });
        }
      } else {
        print(isDoctorLogin);
        print(regNo);
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).onComplete;

        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'name': name,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occured, please check your credentials';

      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      var message = 'You are not a registered Doctor!';

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
