import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
    super.initState();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Verification mail sent please check'),
        backgroundColor: Colors.green,
      ));
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 60));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: Text(
                  'Verification Email has been sent to your email.Please Verify it',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              canResendEmail
                  ? Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xff58BDB4),
                              minimumSize: Size.fromHeight(50)),
                          onPressed: canResendEmail
                              ? () => sendVerificationEmail()
                              : null,
                          icon: Icon(Icons.email),
                          label: Text('Resend Mail')),
                    )
                  : Column(
                    children: [
                      Text(
                  'Retry In :',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(height: 20,),
                      CircularCountDownTimer(textStyle: TextStyle(color: Colors.white,fontSize: 20),
                          width: 100,
                          height: 100,
                          duration: 60,
                          fillColor: Colors.black,
                          ringColor: Color(0xff58BDB4)),
                    ],
                  ),
              TextButton(
                child: Text('Cancel'),
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
          backgroundColor: Colors.black,
        );
}
