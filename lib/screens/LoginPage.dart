import 'package:awesome_icons/awesome_icons.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/forgotPage.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginPage({Key? key, required this.onClickedSignUp}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: Container(
                      height: 100, child: Image.asset('images/tmdb_login.png')),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 8),
                  child: Text(
                    'Welcome Back',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff58BDB4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Enter Email',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 95, 94, 94)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff58BDB4)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Enter Password',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 95, 94, 94)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Enter min 6 characters'
                        : null,
                    obscureText: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xff58BDB4),
                        minimumSize: Size.fromHeight(50)),
                    icon: Icon(Icons.lock_open, size: 20),
                    label: Text(
                      'Log In',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      LogIn();
                    },
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPage(),
                          ));
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xff58BDB4)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                      child: Text('Or Login in Using',
                          style: TextStyle(color: Colors.white))),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right:60.0,left:60,top: 10),
                    child: ElevatedButton.icon(style: ElevatedButton.styleFrom(
                          primary: Color(0xff58BDB4),
                          minimumSize: Size.fromHeight(35)),
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.google),
                      label: Text('Login Using Google'),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.white),
                            text: 'No Account? ',
                            children: [
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignUp,
                              text: 'Sign Up',
                              style: TextStyle(color: Color(0xff58BDB4)))
                        ])),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Future LogIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Error'),
        backgroundColor: Colors.red,
      ));
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
